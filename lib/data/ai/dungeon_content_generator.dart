import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';

import '../../domain/models/chat_message.dart' as model;
import '../repositories/gemini_logic_repository.dart';

class DungeonContentGenerator implements ContentGenerator {
  final Dio _dio;
  final Catalog catalog;
  late final GeminiLogicRepository _logicRepository;

  DungeonContentGenerator({required this.catalog, Dio? dio, String? apiKey})
    : _dio = dio ?? Dio() {
    _logicRepository = GeminiLogicRepository(_dio, apiKey: apiKey);
  }

  String language = 'English';

  final _a2uiMessageController = StreamController<A2uiMessage>.broadcast();
  final _textResponseController = StreamController<String>.broadcast();
  final _errorController = StreamController<ContentGeneratorError>.broadcast();
  final _isProcessing = ValueNotifier<bool>(false);

  final _imagePromptController = StreamController<String?>.broadcast();
  Stream<String?> get imagePromptStream => _imagePromptController.stream;

  String? _lastThoughtSignature;
  String? get currentThoughtSignature => _lastThoughtSignature;

  void restoreContext(String thoughtSignature) {
    _lastThoughtSignature = thoughtSignature;
  }

  @override
  Stream<A2uiMessage> get a2uiMessageStream => _a2uiMessageController.stream;

  @override
  Stream<String> get textResponseStream => _textResponseController.stream;

  @override
  Stream<ContentGeneratorError> get errorStream => _errorController.stream;

  @override
  ValueListenable<bool> get isProcessing => _isProcessing;

  @override
  void dispose() {
    _a2uiMessageController.close();
    _textResponseController.close();
    _imagePromptController.close();
    _errorController.close();
    _isProcessing.dispose();
  }

  @override
  Future<void> sendRequest(
    ChatMessage message, {
    Iterable<ChatMessage>? history,
  }) async {
    _isProcessing.value = true;
    try {
      String userAction = "Continue";
      if (message is UserMessage) {
        userAction = message.text;
      } else if (message is UserUiInteractionMessage) {
        userAction = message.text;
      }

      final convertedHistory = <model.ChatMessage>[];
      if (history != null) {
        for (final msg in history) {
          if (msg is UserMessage) {
            convertedHistory.add(
              model.ChatMessage(text: msg.text, isUser: true),
            );
          } else if (msg is AiTextMessage) {
            convertedHistory.add(
              model.ChatMessage(text: msg.text, isUser: false),
            );
          }
        }
      }

      if (_lastThoughtSignature != null && convertedHistory.isNotEmpty) {
        final lastIdx = convertedHistory.lastIndexWhere((m) => !m.isUser);
        if (lastIdx != -1) {
          convertedHistory[lastIdx] = convertedHistory[lastIdx].copyWith(
            thoughtSignature: _lastThoughtSignature,
          );
        }
      }

      final response = await _logicRepository.sendTurn(
        userAction: userAction,
        history: convertedHistory,
        language: language,
      );

      _lastThoughtSignature = response.thoughtSignature;
      _processResponse(response.json);
    } catch (e, st) {
      _errorController.add(ContentGeneratorError(e, st));
      debugPrint('[DungeonContentGenerator] Error: $e');
    } finally {
      _isProcessing.value = false;
    }
  }

  void _processResponse(Map<String, dynamic> responseJson) {
    if (kDebugMode) {
      print('[DungeonContentGenerator] AI Response: $responseJson');
    }

    final dataUpdates = <Map<String, dynamic>>[];

    // 1. 스토리
    String currentStory = "";
    if (responseJson.containsKey('story')) {
      currentStory = responseJson['story'];
      _textResponseController.add(currentStory);
      dataUpdates.add({
        'key': '/story',
        'value': currentStory,
        'valueString': currentStory,
      });
    }

    // 2. 상태 (Status)
    Map<String, dynamic> currentStatus = {
      'hp': 100,
      'maxHp': 100,
      'mp': 50,
      'maxMp': 50,
      'level': 1,
      'name': 'Hero',
    };

    Map<String, dynamic>? statusData;
    if (responseJson.containsKey('status') && responseJson['status'] is Map) {
      statusData = responseJson['status'];
    } else if (responseJson.containsKey('hp')) {
      statusData = responseJson;
    }

    if (statusData != null) {
      final statusKeys = ['hp', 'maxHp', 'mp', 'maxMp', 'level'];
      for (var key in statusKeys) {
        if (statusData.containsKey(key)) {
          final val = statusData[key];
          dataUpdates.add({'key': '/$key', 'value': val});
          currentStatus[key] = val;
        }
      }
      if (statusData.containsKey('name')) {
        final name = statusData['name'];
        dataUpdates.add({'key': '/name', 'valueString': name, 'value': name});
        currentStatus['name'] = name;
      }
    }

    // 3. 전투 (Combat)
    bool isCombatActive = false;
    String monsterName = "Unknown";
    int monsterHp = 0;
    int monsterMaxHp = 100;

    if (responseJson.containsKey('combat') && responseJson['combat'] is Map) {
      final combat = responseJson['combat'];
      isCombatActive = combat['isActive'] == true;

      if (isCombatActive) {
        if (combat.containsKey('monsterName')) {
          final mName = combat['monsterName'];
          dataUpdates.add({
            'key': '/combat/monsterName',
            'valueString': mName,
            'value': mName,
          });
          monsterName = mName ?? "Unknown";
        }
        if (combat.containsKey('monsterHp')) {
          final mHp = combat['monsterHp'];
          dataUpdates.add({'key': '/combat/monsterHp', 'value': mHp});
          monsterHp = mHp ?? 0;
        }
        if (combat.containsKey('monsterMaxHp')) {
          final mMaxHp = combat['monsterMaxHp'];
          dataUpdates.add({'key': '/combat/monsterMaxHp', 'value': mMaxHp});
          monsterMaxHp = mMaxHp ?? 100;
        }
      }
    }

    // 4. 이미지 프롬프트 (GenUI 외부에서 처리하므로 스트림만 전송)
    if (responseJson.containsKey('image_prompt')) {
      final prompt = responseJson['image_prompt'];
      _imagePromptController.add(prompt);
    } else {
      _imagePromptController.add(null);
    }

    // 5. UI 트리 구성
    final components = <String, Map<String, dynamic>>{};
    var idCounter = 0;
    int nextId() => idCounter++;

    Map<String, dynamic> uiData = responseJson['ui'] is Map<String, dynamic>
        ? responseJson['ui']
        : {};

    // [UI Adapter 1] 루트가 타입 없이 리스트 형태인 경우 (fallback)
    if (!uiData.containsKey('type') && !_isKeyAsType(uiData)) {
      List? actions;
      final potentialKeys = [
        'choices',
        'main_actions',
        'actions',
        'interaction',
        'menu',
        'buttons',
        'items',
      ];
      for (var key in potentialKeys) {
        if (uiData.containsKey(key) && uiData[key] is List) {
          actions = uiData[key] as List;
          break;
        }
      }

      if (actions == null) {
        for (var value in uiData.values) {
          if (value is List && value.isNotEmpty && value.first is Map) {
            actions = value;
            break;
          }
        }
      }

      if (actions != null) {
        // 발견된 리스트를 Column으로 감싸기
        uiData = {
          'type': 'column',
          'children': actions, // 내부 아이템은 _convertUiNode에서 재귀적으로 처리됨
        };
      }
    }

    String aiRootId;
    if (uiData.isNotEmpty) {
      aiRootId = _convertUiNode(uiData, components, nextId);
    } else {
      aiRootId = 'gen_${nextId()}';
      components[aiRootId] = {
        'Text': {
          'text': {'literalString': ''},
        },
      };
    }

    // 정적 컴포넌트
    final statusId = 'static_status_widget';
    components[statusId] = {
      'StatusWidget': {
        'hp': {'path': '/hp', 'literalNumber': currentStatus['hp']},
        'maxHp': {'path': '/maxHp', 'literalNumber': currentStatus['maxHp']},
        'mp': {'path': '/mp', 'literalNumber': currentStatus['mp']},
        'maxMp': {'path': '/maxMp', 'literalNumber': currentStatus['maxMp']},
        'level': {'path': '/level', 'literalNumber': currentStatus['level']},
        'name': {'path': '/name', 'literalString': currentStatus['name']},
      },
    };

    final storyTextId = 'static_story_text';
    components[storyTextId] = {
      'Text': {
        'text': {'literalString': currentStory},
      },
    };

    final monsterId = 'static_monster_widget';
    components[monsterId] = {
      'MonsterWidget': {
        'name': {'path': '/combat/monsterName', 'literalString': monsterName},
        'hp': {'path': '/combat/monsterHp', 'literalNumber': monsterHp},
        'maxHp': {
          'path': '/combat/monsterMaxHp',
          'literalNumber': monsterMaxHp,
        },
      },
    };

    final rootId = 'static_root_column';
    List<String> childrenIds = [statusId];
    if (isCombatActive) {
      childrenIds.add(monsterId);
    }
    childrenIds.add(storyTextId);
    childrenIds.add(aiRootId);

    components[rootId] = {
      'Column': {
        'children': {'explicitList': childrenIds},
      },
    };

    // 1. Surface 생성
    _a2uiMessageController.add(
      A2uiMessage.fromJson({
        'surfaceUpdate': {
          'surfaceId': 'main_game',
          'components': components.entries
              .map((e) => {'id': e.key, 'component': e.value})
              .toList(),
        },
      }),
    );

    // 2. 데이터 업데이트
    if (dataUpdates.isNotEmpty) {
      _a2uiMessageController.add(
        A2uiMessage.fromJson({
          'dataModelUpdate': {
            'surfaceId': 'main_game',
            'contents': dataUpdates,
          },
        }),
      );
    }

    // 3. 렌더링
    _a2uiMessageController.add(
      A2uiMessage.fromJson({
        'beginRendering': {'surfaceId': 'main_game', 'root': rootId},
      }),
    );

    if (responseJson.containsKey('ui_messages')) {
      final messages = responseJson['ui_messages'] as List;
      for (final msg in messages) {
        if (msg is Map<String, dynamic>) {
          _a2uiMessageController.add(A2uiMessage.fromJson(msg));
        }
      }
    }
  }

  // 헬퍼: Key가 Type인지 확인
  bool _isKeyAsType(Map<String, dynamic> node) {
    const knownTypes = ['column', 'row', 'text', 'button', 'input'];
    for (var key in node.keys) {
      if (knownTypes.contains(key.toLowerCase())) return true;
    }
    return false;
  }

  String _convertUiNode(
    Map<String, dynamic> node,
    Map<String, Map<String, dynamic>> components,
    int Function() nextId, {
    int depth = 0,
  }) {
    if (depth > 50) {
      final id = 'gen_${nextId()}';
      components[id] = {
        'Text': {
          'text': {'literalString': 'Depth Limit'},
        },
      };
      return id;
    }

    const knownTypes = ['column', 'row', 'text', 'button', 'input'];

    // [UI Adapter 2] Key-as-Type 처리 (예: {"column": [...]})
    // type 키가 없는데 knownType 키가 발견되면 구조를 정규화함
    if (!node.containsKey('type')) {
      for (final key in node.keys) {
        if (knownTypes.contains(key.toLowerCase())) {
          final content = node[key];

          // Node 복사 및 재구성
          if (content is Map<String, dynamic>) {
            node = Map.of(content);
          } else if (content is List) {
            // List인 경우 children으로 감싸줌 (이게 핵심!)
            node = {'children': content};
          } else {
            // String이나 기타 값인 경우 content/text로 감싸줌
            node = {'text': content.toString()};
          }

          node['type'] = key; // 타입 명시
          break;
        }
      }
    }

    String? type = (node['type'] as String?)?.toLowerCase();

    // [UI Adapter 3] 타입 추론 실패 시 (리스트 아이템 등)
    if (type == null || !knownTypes.contains(type)) {
      // 텍스트인지 버튼인지 추론
      if (node.containsKey('action') ||
          node.containsKey('command') ||
          node.containsKey('id')) {
        type = 'button';
      } else if (node.containsKey('children')) {
        type = 'column';
      } else {
        type = 'text'; // 기본값
      }
      // node['type'] = type; // (Optional)
    }

    final id = 'gen_${nextId()}';
    String componentName = 'Text';
    Map<String, dynamic> properties = {};

    switch (type) {
      case 'column':
        componentName = 'Column';
        final children = (node['children'] as List? ?? [])
            .map((c) {
              if (c is Map<String, dynamic>) {
                return _convertUiNode(c, components, nextId, depth: depth + 1);
              }
              return null;
            })
            .whereType<String>()
            .toList();
        properties = {
          'children': {'explicitList': children},
        };
        break;

      case 'row':
        componentName = 'Row';
        final children = (node['children'] as List? ?? [])
            .map((c) {
              if (c is Map<String, dynamic>) {
                return _convertUiNode(c, components, nextId, depth: depth + 1);
              }
              return null;
            })
            .whereType<String>()
            .toList();
        properties = {
          'children': {'explicitList': children},
        };
        break;

      case 'text':
        componentName = 'Text';
        String content =
            node['content'] ??
            node['text'] ??
            node['title'] ??
            node['description'] ??
            node['value'] ??
            '';
        // 리스트 내부에서 텍스트만 있는 경우 (예: {"text": "..."}) 처리
        if (content.isEmpty &&
            node.containsKey('text') &&
            node['text'] is Map) {
          content = (node['text'] as Map)['value'] ?? '';
        }
        properties = {
          'text': {'literalString': content},
        };
        break;

      case 'button':
        final label =
            node['label'] ??
            node['text'] ??
            node['name'] ??
            node['value'] ??
            'Button';
        final textId = 'gen_${nextId()}';
        components[textId] = {
          'Text': {
            'text': {'literalString': label},
          },
        };

        // [핵심] Action 객체 정규화 (Map -> ActionId String 추출)
        var rawAction =
            node['action'] ?? node['command'] ?? node['id'] ?? node['context'];
        String actionString = '';

        if (rawAction is Map) {
          // 만약 action이 {name: performAction, context: {actionId: ...}} 형태라면 actionId만 추출
          if (rawAction.containsKey('context') && rawAction['context'] is Map) {
            actionString =
                rawAction['context']['actionId']?.toString() ??
                jsonEncode(rawAction);
          } else {
            actionString = jsonEncode(rawAction);
          }
        } else if (rawAction is List) {
          actionString = jsonEncode(rawAction);
        } else {
          actionString = rawAction?.toString() ?? 'unknown';
        }

        componentName = 'Button';
        properties = {
          'child': textId,
          'action': {
            'name': 'performAction',
            'context': [
              {
                'key': 'actionId',
                'value': {'literalString': actionString},
              },
            ],
          },
        };
        break;

      case 'input':
        componentName = 'TextField';
        properties = {
          'label': {'literalString': node['hint'] ?? 'Input'},
          'text': {'path': '/input_value'},
          'onSubmittedAction': {
            'name': 'performAction',
            'context': [
              {
                'key': 'actionId',
                'value': {'literalString': 'input_submission'},
              },
              {
                'key': 'value',
                'value': {'path': '/input_value'},
              },
            ],
          },
        };
        break;

      default:
        properties = {
          'text': {'literalString': 'Unknown: $type'},
        };
    }

    components[id] = {componentName: properties};
    return id;
  }
}
