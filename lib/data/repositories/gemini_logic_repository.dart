import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/chat_message.dart';

class LogicResponse {
  final Map<String, dynamic> json;
  final String? thoughtSignature;

  LogicResponse(this.json, this.thoughtSignature);
}

class GeminiLogicRepository {
  final Dio _dio;
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  final String? _apiKeyOverride;

  GeminiLogicRepository(this._dio, {String? apiKey}) : _apiKeyOverride = apiKey;

  String get _apiKey => _apiKeyOverride?.isNotEmpty == true
      ? _apiKeyOverride!
      : dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<LogicResponse> sendTurn({
    required String userAction,
    required List<ChatMessage> history,
    required String language,
  }) async {
    final url = '$_baseUrl/gemini-2.5-flash:generateContent?key=$_apiKey';

    // 1. 히스토리 구성
    final contents = history.map((msg) {
      String textContent = msg.text;
      if (msg.thoughtSignature != null && msg.thoughtSignature!.isNotEmpty) {
        textContent +=
            "\n\n<GameMemory>\n${msg.thoughtSignature}\n</GameMemory>";
      }
      return {
        "role": msg.isUser ? "user" : "model",
        "parts": [
          {"text": textContent},
        ],
      };
    }).toList();

    contents.add({
      "role": "user",
      "parts": [
        {"text": userAction},
      ],
    });

    // 2. 시스템 프롬프트
    final systemInstructionText =
        """
You are a Dungeon Master for a text-based RPG.
Response MUST be a valid JSON object.

### JSON Output Structure
{
  "story": "Narrative text in $language.",
  "image_prompt": "Visual description in English.",
  "status": {
    "name": "Player",
    "hp": <int>,
    "maxHp": <int>,
    "mp": <int>,
    "maxMp": <int>,
    "level": <int>
  },
  "combat": {
    "isActive": <bool>,
    "monsterName": <string?>,
    "monsterHp": <int?>,
    "monsterMaxHp": <int?>
  },
  "ui": { ... }, 
  "thought_signature": "..."
}

### STRICT UI Rules
1. Construct 'ui' using ONLY: 'column', 'row', 'text', 'button', 'input'.
2. Do not use custom types like 'inventory'. Use 'column' with 'text'/'button' children instead.
3. Return ONLY the JSON object.
""";

    final body = {
      "system_instruction": {
        "parts": [
          {"text": systemInstructionText},
        ],
      },
      "contents": contents,
      "generationConfig": {"responseMimeType": "application/json"},
    };

    try {
      final response = await _dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: body,
      );

      if (kDebugMode) {
        debugPrint('[GeminiLogicRepository] Raw Response: ${response.data}');
      }

      final candidate = response.data['candidates'][0];
      final parts = candidate['content']['parts'] as List;
      final textPart = parts.firstWhere(
        (p) => p.containsKey('text'),
        orElse: () => {'text': '{}'},
      );
      String jsonText = textPart['text'];

      // [1] JSON 구간 추출 ({ ... })
      final startIndex = jsonText.indexOf('{');
      final endIndex = jsonText.lastIndexOf('}');
      if (startIndex != -1 && endIndex != -1) {
        jsonText = jsonText.substring(startIndex, endIndex + 1);
      } else {
        throw FormatException("No JSON object found");
      }

      // [2] 제어 문자 정제 (핵심 수정)
      // AI가 문자열 내부에 실제 줄바꿈(0x0A) 등을 넣으면 파싱 에러가 발생하므로 공백으로 치환합니다.
      // (유효한 JSON 줄바꿈은 \n 문자로 이스케이프되어 있어야 함)
      jsonText = jsonText.replaceAll(RegExp(r'[\x00-\x1F]'), ' ');

      final Map<String, dynamic> parsedJson = jsonDecode(jsonText);

      if (kDebugMode) {
        debugPrint('[GeminiLogicRepository] Parsed JSON Success');
      }

      return LogicResponse(parsedJson, parsedJson['thought_signature']);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[GeminiLogicRepository] Parsing Error: $e');
        debugPrintStack(stackTrace: st);
      }

      // 에러 발생 시 폴백 데이터 반환
      return LogicResponse({
        "story": "통신 상태가 불안정하여 마법의 연결이 잠시 끊겼습니다. 다시 시도해주세요. (Error: $e)",
        "image_prompt": null,
        "status": {
          "hp": 100,
          "maxHp": 100,
          "mp": 50,
          "maxMp": 50,
          "level": 1,
          "name": "Player",
        },
        "combat": {"isActive": false},
        "ui": {
          "type": "column",
          "children": [
            {"type": "button", "label": "다시 시도", "action": "retry"},
          ],
        },
      }, null);
    }
  }
}
