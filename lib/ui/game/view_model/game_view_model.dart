import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genui/genui.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/game_state.dart';
import '../../../domain/models/game_turn.dart';
import '../../../domain/models/chat_message.dart' as model;
import '../../../data/ai/dungeon_content_generator.dart';
import '../../../data/repositories/gemini_image_repository.dart';
import '../../../data/repositories/game_state_repository.dart';
import '../../../ui/game/genui/dungeon_catalog.dart';
import '../../../providers/game_config_provider.dart';
import '../../../providers/locale_provider.dart';

final dioProvider = Provider((ref) => Dio());

final gameViewModelProvider = NotifierProvider<GameViewModel, GameState>(
  GameViewModel.new,
);

class GameViewModel extends Notifier<GameState> {
  late final GenUiManager _genUiManager;
  late final GenUiConversation _conversation;
  late final DungeonContentGenerator _contentGenerator;
  late final GeminiImageRepository _imageRepository;
  late final GameStateRepository _stateRepository;
  final _uuid = const Uuid();

  String? _lastProcessedPrompt;
  bool _isInitialized = false;

  /// Track if we've attempted to load saved state
  bool _hasAttemptedLoad = false;

  /// Future that completes when state loading is done
  Future<void>? _loadingFuture;

  GenUiManager get genUiManager => _genUiManager;

  @override
  GameState build() {
    final dio = ref.read(dioProvider);
    final config = ref.watch(gameConfigProvider);
    _imageRepository = GeminiImageRepository(dio, apiKey: config.apiKey);
    _stateRepository = GameStateRepository();

    _genUiManager = GenUiManager(catalog: dungeonCatalog);
    _contentGenerator = DungeonContentGenerator(
      catalog: dungeonCatalog,
      dio: dio,
      apiKey: config.apiKey,
    );
    _conversation = GenUiConversation(
      contentGenerator: _contentGenerator,
      genUiManager: _genUiManager,
    );

    _contentGenerator.isProcessing.addListener(_onProcessingChanged);

    // 메시지가 올 때마다 데이터 구독 재시도 (초기화 타이밍 이슈 해결)
    final messageSub = _contentGenerator.a2uiMessageStream.listen((event) {
      // _checkSubscription(); // Removed
    });

    final textSub = _contentGenerator.textResponseStream.listen((text) {
      state = state.copyWith(
        history: [
          ...state.history,
          model.ChatMessage(text: text, isUser: false),
        ],
      );
    });

    final promptSub = _contentGenerator.imagePromptStream.listen((prompt) {
      _handlePromptChange(prompt);
    });

    // Start loading saved state (async)
    _loadingFuture = _loadSavedState();

    ref.onDispose(() {
      _contentGenerator.isProcessing.removeListener(_onProcessingChanged);
      promptSub.cancel();
      messageSub.cancel();
      textSub.cancel();
      _conversation.dispose();
      _contentGenerator.dispose();
      _genUiManager.dispose();
    });

    return const GameState();
  }

  /// Load saved game state from local storage
  Future<void> _loadSavedState() async {
    if (_hasAttemptedLoad) return;
    _hasAttemptedLoad = true;

    try {
      final savedState = await _stateRepository.loadGameState();
      if (savedState != null && savedState.turns.isNotEmpty) {
        if (kDebugMode) {
          debugPrint(
            '[GameViewModel] Loaded saved state with ${savedState.turns.length} turns',
          );
        }
        state = savedState;

        // Restore the last thought signature
        if (savedState.turns.isNotEmpty) {
          _contentGenerator.restoreContext(
            savedState.turns.last.thoughtSignature,
          );

          // Restore the GenUI data model with the last turn's state
          try {
            final lastTurn = savedState.turns.last;
            final dataModel = _genUiManager.dataModelForSurface('main_game');

            // Restore status data
            lastTurn.statusSnapshot.forEach((key, value) {
              dataModel.update(DataPath('/$key'), value);
            });

            // Restore story and image data
            dataModel.update(DataPath('/story'), lastTurn.storyText);
            if (lastTurn.imagePrompt != null) {
              dataModel.update(DataPath('/prompt'), lastTurn.imagePrompt);
            }
            if (lastTurn.imageData != null) {
              dataModel.update(
                DataPath('/imageData'),
                base64Encode(lastTurn.imageData!),
              );
            }

            if (kDebugMode) {
              debugPrint('[GameViewModel] GenUI data model restored');
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint('[GameViewModel] Error restoring GenUI data: $e');
            }
          }
        }

        _isInitialized = true;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GameViewModel] Error loading saved state: $e');
      }
    }
  }

  /// Save current game state to local storage
  Future<void> _saveState() async {
    if (!_isInitialized) return; // Don't save during initial load

    try {
      await _stateRepository.saveGameState(state);
      if (kDebugMode) {
        debugPrint('[GameViewModel] Game state saved');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GameViewModel] Error saving state: $e');
      }
    }
  }

  /// Clear saved game state without starting a new game
  Future<void> clearGameState() async {
    await _stateRepository.clearGameState();
    state = const GameState();
    _isInitialized = false;
    _hasAttemptedLoad = false;

    // Clear GenUI data model
    try {
      final dataModel = _genUiManager.dataModelForSurface('main_game');
      // Reset all data paths to default values
      dataModel.update(DataPath('/hp'), 100);
      dataModel.update(DataPath('/maxHp'), 100);
      dataModel.update(DataPath('/mp'), 50);
      dataModel.update(DataPath('/maxMp'), 50);
      dataModel.update(DataPath('/level'), 1);
      dataModel.update(DataPath('/name'), 'Hero');
      dataModel.update(DataPath('/story'), '');
      dataModel.update(DataPath('/prompt'), null);
      dataModel.update(DataPath('/imageData'), null);
      dataModel.update(DataPath('/combat/monsterName'), '');
      dataModel.update(DataPath('/combat/monsterHp'), 0);
      dataModel.update(DataPath('/combat/monsterMaxHp'), 100);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GameViewModel] Error clearing GenUI data: $e');
      }
    }

    // Reset content generator context
    _contentGenerator.restoreContext('');
    _lastProcessedPrompt = null;
  }

  /// Clear saved game state and start a new game
  Future<void> startNewGame(String startPrompt) async {
    await _stateRepository.clearGameState();
    state = const GameState();
    _isInitialized = true;
    final config = ref.read(gameConfigProvider);
    final initialPrompt =
        "$startPrompt\n\nPlayer Info:\nName: ${config.characterName}\nClass: ${config.characterClass}";

    final locale = ref.read(localeProvider);
    _contentGenerator.language = getLanguageName(locale);

    await performAction(initialPrompt);
  }

  void _onProcessingChanged() {
    state = state.copyWith(
      isGeneratingText: _contentGenerator.isProcessing.value,
    );

    if (!state.isGeneratingText && !state.isGeneratingImage) {
      _snapshotTurn();
    }
  }

  Future<void> _handlePromptChange(String? prompt) async {
    if (prompt == null || prompt.isEmpty || prompt == _lastProcessedPrompt) {
      return;
    }

    if (kDebugMode) {
      debugPrint('[GameViewModel] Image Prompt Detected: $prompt');
    }
    _lastProcessedPrompt = prompt;

    state = state.copyWith(isGeneratingImage: true, currentImagePrompt: prompt);

    try {
      String? referenceBase64;
      if (state.currentImage != null) {
        referenceBase64 = base64Encode(state.currentImage!);
      }

      final imageBytes = await _imageRepository.generateImage(
        prompt: prompt,
        referenceBase64: referenceBase64,
      );

      if (imageBytes != null) {
        if (kDebugMode) {
          debugPrint(
            '[GameViewModel] Image Generated (${imageBytes.length} bytes)',
          );
        }

        state = state.copyWith(currentImage: imageBytes);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[GameViewModel] Image gen error: $e');
    } finally {
      state = state.copyWith(isGeneratingImage: false);
      if (!state.isGeneratingText) {
        _snapshotTurn();
      }
    }
  }

  void _snapshotTurn() {
    if (_contentGenerator.currentThoughtSignature == null) return;
    if (state.turns.isNotEmpty &&
        state.turns.last.thoughtSignature ==
            _contentGenerator.currentThoughtSignature) {
      return;
    }
    if (state.history.isEmpty) return;

    try {
      final dataModel = _genUiManager.dataModelForSurface('main_game');
      final statusSnapshot = <String, dynamic>{
        'hp': dataModel.getValue<int>(DataPath('/hp')) ?? 0,
        'maxHp': dataModel.getValue<int>(DataPath('/maxHp')) ?? 100,
        'mp': dataModel.getValue<int>(DataPath('/mp')) ?? 0,
        'maxMp': dataModel.getValue<int>(DataPath('/maxMp')) ?? 50,
        'level': dataModel.getValue<int>(DataPath('/level')) ?? 1,
        'name': dataModel.getValue<String>(DataPath('/name')) ?? 'Hero',
      };

      String userAction = '';
      String storyText = '';

      if (!state.history.last.isUser) {
        storyText = state.history.last.text;
        if (state.history.length > 1 &&
            state.history[state.history.length - 2].isUser) {
          userAction = state.history[state.history.length - 2].text;
        }
      } else {
        return;
      }

      final turn = GameTurn(
        id: _uuid.v4(),
        userAction: userAction,
        storyText: storyText,
        imagePrompt: state.currentImagePrompt,
        imageData: state.currentImage,
        statusSnapshot: statusSnapshot,
        thoughtSignature: _contentGenerator.currentThoughtSignature!,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        turns: [...state.turns, turn],
        currentTurnIndex: state.turns.length,
      );

      // Auto-save after adding a new turn
      _saveState();
    } catch (e) {
      //
    }
  }

  Future<void> restoreTurn(GameTurn turn) async {
    state = state.copyWith(
      currentImage: turn.imageData,
      currentImagePrompt: turn.imagePrompt,
      turns: state.turns.sublist(0, state.turns.indexOf(turn) + 1),
      currentTurnIndex: state.turns.indexOf(turn),
    );

    _contentGenerator.restoreContext(turn.thoughtSignature);

    try {
      final dataModel = _genUiManager.dataModelForSurface('main_game');
      turn.statusSnapshot.forEach((key, value) {
        dataModel.update(DataPath('/$key'), value);
      });

      if (turn.imagePrompt != null) {
        dataModel.update(DataPath('/prompt'), turn.imagePrompt);
      }
      dataModel.update(DataPath('/story'), turn.storyText);
      dataModel.update(
        DataPath('/imageData'),
        turn.imageData != null ? base64Encode(turn.imageData!) : null,
      );
    } catch (e) {
      //
    }

    // Auto-save after restoring to a previous turn
    _saveState();
  }

  Future<void> startGame(String startPrompt) async {
    // Wait for saved state to load before deciding to start a new game
    if (_loadingFuture != null) {
      await _loadingFuture;
    }

    // If we loaded a saved state, don't start a new game
    if (state.history.isNotEmpty || state.turns.isNotEmpty) {
      if (kDebugMode) {
        debugPrint('[GameViewModel] Resuming from saved state');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('[GameViewModel] Starting new game');
    }
    await startNewGame(startPrompt);
  }

  Future<void> performAction(String action) async {
    final userMsg = model.ChatMessage(text: action, isUser: true);
    state = state.copyWith(history: [...state.history, userMsg]);

    final locale = ref.read(localeProvider);
    _contentGenerator.language = getLanguageName(locale);

    await _conversation.sendRequest(UserMessage.text(action));
  }
}
