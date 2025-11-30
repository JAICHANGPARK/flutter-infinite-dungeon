---
trigger: always_on
---

# 🏛️ Project Context: Infinite Dungeon with GenUI

* Make sure all the code is properly commented

## 1. 🏗️ Tech Stack & Architecture

이 프로젝트는 **Flutter 공식 아키텍처(Compass Style)**와 **REST API(Dio)**를 사용하여 구현됩니다.

### Architecture: Hybrid MVVM
- **UI Layer (`ui/`)**: Feature-first 구조 (View + ViewModel).
- **Domain Layer (`domain/`)**: 비즈니스 모델 (Entity).
- **Data Layer (`data/`)**: API 통신 및 데이터 가공 (Repository).

### Core Libraries
- **Language**: Dart (Latest), Flutter (Latest stable)
- **State Management**: **Riverpod** (Notifier / AsyncNotifier)
- **Networking**: **Dio** (REST API 필수)
- **Env Management**: `flutter_dotenv` (API Key)
- **Data Class**: Freezed & JsonSerializable
- **UI Generation**: `flutter_genui` flutter package

### Text & Logic Generation (The Brain)
- **Role**: `gemini-2.5-flash`는 게임의 **두뇌**입니다.
- **Responsibility**:
  1. 게임 로직 판정 (성공/실패 여부).
  2. `flutter_genui`를 위한 **JSON 위젯 데이터 생성**. (가장 중요)
  3. `Nano Banana Pro`에게 전달할 **상세한 이미지 프롬프트(image_prompt) 작문**.
  4. 대사 및 상황 묘사 텍스트 생성.

---

## 2. 📜 API & Development Rules (Strict REST Mode)

### Rule 1: Text & Logic Generation (Game Master)
- **Model**: `gemini-2.5-flash` (빠른 응답 속도, 로직 처리용).
- **Endpoint**: `.../models/gemini-2.5-flash:generateContent`
- **Configuration**:
  - `responseMimeType`: `"application/json"` (GenUI 파싱을 위해 JSON 강제).
  - `system_instruction`: "RPG Game Master" 페르소나 주입.

### Rule 2: Image Generation (Nano Banana Pro)
- **Model**: `gemini-3-pro-image-preview` (고품질 이미지, 텍스트 렌더링).
- **Endpoint**: `.../models/gemini-3-pro-image-preview:generateContent`
- **Configuration**:
  - `responseModalities`: `["TEXT", "IMAGE"]` (필수).
  - `imageConfig`: `{"aspectRatio": "16:9" (또는 상황별), "imageSize": "2K"}`.
- **Handling**:
  - 응답은 **Base64**로 오므로 `base64Decode` 후 `MemoryImage`로 렌더링한다.
  - **편집(Editing)**: 기존 이미지를 수정할 때는 이전 이미지의 Base64를 `inline_data`로 포함하여 요청한다.

### Rule 3: Thinking Process & Thought Signatures (Critical)
- **Gemini 3의 특징**: 복잡한 작업 시 "Thinking" 과정이 포함되며, 응답에 `thought_signature`가 포함될 수 있다.
- **Context 유지**: SDK가 없으므로, 이전 턴의 응답에 `thought_signature`가 있었다면, **다음 요청의 `contents`에 이를 반드시 포함**해서 보내야 한다. 그렇지 않으면 문맥이 끊긴다.

---

## 3. 📂 Folder Structure

```text
lib/
├── config/                 # .env, theme
├── domain/models/
│   ├── game_state.dart      # 게임 상태 (Freezed)
│   └── chat_message.dart    # 대화 기록 (thought_signature 필드 필수)
├── data/repositories/
│   ├── gemini_logic_repository.dart  # 텍스트/게임 로직 (JSON)
│   └── gemini_image_repository.dart  # 이미지 생성/편집 (Base64)
└── ui/
    ├── core/genui/         # GenUI Catalog & Schema
    └── game/               # Game Feature
        ├── view_model/     # GameViewModel
        ├── widgets/        # Game Specific Widgets
        └── game_screen.dart
```

---

## 4. 🧩 Implementation Hints (REST API Spec)

AI가 코드를 짤 때 참고할 **실제 구현 템플릿**입니다.

### A. Gemini Image Repository (이미지 생성/편집)
*Gemini 3 Pro Image API 문서를 반영한 Dio 구현체입니다.*

```dart
// data/repositories/gemini_image_repository.dart
class GeminiImageRepository {
  final Dio _dio;
  final String _apiKey = dotenv.env['GEMINI_API_KEY']!;
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';

  Future<Uint8List?> generateImage({
    required String prompt,
    String? referenceBase64, // 이미지가 있다면 편집 모드
  }) async {
    final url = '$_baseUrl/gemini-3-pro-image-preview:generateContent?key=$_apiKey';
    
    // 1. Construct Parts
    final List<Map<String, dynamic>> parts = [
      {"text": prompt}
    ];

    // 편집 모드일 경우 기존 이미지 추가 (Reference Image)
    if (referenceBase64 != null) {
      parts.add({
        "inline_data": {
          "mime_type": "image/png",
          "data": referenceBase64
        }
      });
    }

    // 2. Request Body
    final body = {
      "contents": [{"parts": parts}],
      "generationConfig": {
        "responseModalities": ["TEXT", "IMAGE"], // 필수 설정
        "imageConfig": {
          "aspectRatio": "16:9",
          "imageSize": "2K" // 고해상도 요청
        }
      }
    };

    try {
      final response = await _dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: body,
      );

      // 3. Parse Base64 Image from Response
      final candidates = response.data['candidates'] as List;
      if (candidates.isNotEmpty) {
        final parts = candidates[0]['content']['parts'] as List;
        // inlineData가 있는 파트를 찾음
        final imagePart = parts.firstWhere(
          (p) => p.containsKey('inlineData'),
          orElse: () => null,
        );

        if (imagePart != null) {
          final base64String = imagePart['inlineData']['data'];
          return base64Decode(base64String);
        }
      }
      return null;
    } catch (e) {
      print('Image Gen Error: $e');
      return null;
    }
  }
}
```

### B. Gemini Logic Repository (게임 로직 & Thought Signature)
*멀티턴 대화와 사고 서명(Thought Signature) 관리가 포함된 구현체입니다.*

```dart
// data/repositories/gemini_logic_repository.dart
class GeminiLogicRepository {
  final Dio _dio;
  // ... init ...

  Future<GameResponse> sendTurn({
    required String userAction,
    required List<ChatMessage> history, // 이전 대화 기록
  }) async {
    final url = '$_baseUrl/gemini-2.5-flash:generateContent?key=$_apiKey';

    // 1. Build History with Thought Signatures
    final contents = history.map((msg) {
      final part = <String, dynamic>{
        "text": msg.text
      };
      
      // 중요: 이전 턴에서 받은 thought_signature가 있다면 반드시 포함해서 보내야 함
      if (msg.thoughtSignature != null) {
        part["thought_signature"] = msg.thoughtSignature;
      }
      
      return {
        "role": msg.isUser ? "user" : "model",
        "parts": [part]
      };
    }).toList();

    // 현재 유저 입력 추가
    contents.add({
      "role": "user",
      "parts": [{"text": userAction}]
    });

    // 2. Body
    final body = {
      "system_instruction": {
        "parts": [{ "text": "You are a RPG Game Master. Return JSON only..." }]
      },
      "contents": contents,
      "generationConfig": {
        "responseMimeType": "application/json"
      }
    };

    // 3. Request & Parse
    final response = await _dio.post(url, data: body);
    // ... JSON 파싱 로직 (response에 thought_signature가 오면 저장해야 함) ...
  }
}
```

---

## 5. 🔄 Data Flow (Lifecycle)

1. **User Action**: 버튼 클릭 -> `GameViewModel` 호출.
2. **Logic Step**:
   - `GeminiLogicRepository`가 `gemini-2.5-flash`를 호출하여 스토리와 `image_prompt`가 담긴 JSON을 받아옴.
   - 이때 응답 헤더나 바디에 `thought_signature`가 있다면 `ChatMessage` 모델에 저장.
3. **GenUI Rendering**:
   - 받아온 JSON 데이터로 즉시 텍스트와 버튼 UI 렌더링.
   - 이미지 영역은 로딩 표시.
4. **Image Step (Async)**:
   - `GameViewModel`이 `image_prompt`를 감지하여 `GeminiImageRepository` 호출.
   - `gemini-3-pro-image-preview`가 Base64 이미지 반환.
   - `MemoryImage`로 변환하여 화면에 `FadeIn`.

