# 🏛️ Project Context: Infinite Dungeon with GenUI

이 프로젝트는 **Flutter**와 **Google Gemini API**를 활용한 "완전 생성형 RPG (Infinite Dungeon)"입니다.
모든 UI는 `flutter_genui`를 통해 동적으로 생성되며, 게임 로직은 `gemini-2.5-flash`가, 이미지 렌더링은 `gemini-3-pro-image-preview`가 담당합니다.

---

## 1. 🏗️ Tech Stack & Architecture

### Core Tech
- **Framework**: Flutter (Latest Stable)
- **Language**: Dart
- **Architecture**: Hybrid MVVM (Compass Style)
- **State Management**: **Riverpod** (Notifier / AsyncNotifier)
- **Networking**: **Dio** (Strict REST API Mode - No Client SDK)
- **Env**: `flutter_dotenv`
- **Serialization**: Freezed & JsonSerializable
- **UI Engine**: `flutter_genui` (JSON-based UI generation)

### Folder Structure
```text
lib/
├── config/                 # .env, theme
├── domain/models/
│   ├── game_state.dart     # Freezed Data Class
│   └── chat_message.dart   # thought_signature 필드 필수 포함
├── data/repositories/
│   ├── gemini_logic_repository.dart  # gemini-2.5-flash (REST)
│   └── gemini_image_repository.dart  # gemini-3-pro (REST)
└── ui/
    ├── core/genui/         # GenUI Catalog & Schema
    └── game/
        ├── view_model/     # GameViewModel (Riverpod)
        ├── widgets/        # Custom Widgets
        └── game_screen.dart
```

---

## 2. 🤖 AI Model Strategy & Rules

### Role 1: Game Master (Logic & Text)
- **Model**: `gemini-2.5-flash`
- **Endpoint**: `.../models/gemini-2.5-flash:generateContent`
- **Responsibility**:
  1. 게임 진행 및 성공/실패 판정.
  2. `flutter_genui` 스펙에 맞는 **JSON 데이터 생성**.
  3. 이미지 생성을 위한 상세한 **`image_prompt` 작문**.
  4. **Thought Signature 관리**: 복잡한 추론 문맥 유지를 위해 이전 턴의 `thought_signature`를 다음 요청에 반드시 포함.

### Role 2: Visual Renderer (Nano Banana Pro)
- **Model**: `gemini-3-pro-image-preview`
- **Endpoint**: `.../models/gemini-3-pro-image-preview:generateContent`
- **Responsibility**:
  1. 고품질 텍스트 렌더링 (간판, 문서 등).
  2. 캐릭터 일관성 유지.
  3. **Reasoning-based Editing**: 기존 이미지를 `inline_data`로 받아 수정(예: 횃불 켜기, 검으로 베기 등).

---

## 3. 📜 Implementation Rules (Strict REST)

**중요**: Google Generative AI SDK를 사용하지 않고, **Dio를 사용하여 직접 REST API를 호출**합니다.

### A. Gemini Logic Repository Implementation
`gemini-2.5-flash` 호출 시 JSON 강제(`responseMimeType`)와 `thought_signature` 처리가 필수입니다.

```dart
// Reference: data/repositories/gemini_logic_repository.dart
Future<GameResponse> sendTurn({
  required String userAction,
  required List<ChatMessage> history,
}) async {
  final url = '$_baseUrl/gemini-2.5-flash:generateContent?key=$_apiKey';

  final contents = history.map((msg) {
    final part = <String, dynamic>{"text": msg.text};
    // [CRITICAL] 이전 턴의 생각(thought_signature)이 있다면 문맥 유지를 위해 포함
    if (msg.thoughtSignature != null) {
      part["thought_signature"] = msg.thoughtSignature;
    }
    return {
      "role": msg.isUser ? "user" : "model",
      "parts": [part]
    };
  }).toList();

  contents.add({
    "role": "user",
    "parts": [{"text": userAction}] // 현재 유저 액션
  });

  final body = {
    "system_instruction": {
      "parts": [{ "text": "You are a RPG Game Master. Output MUST be strictly JSON format for GenUI..." }]
    },
    "contents": contents,
    "generationConfig": {
      "responseMimeType": "application/json" // JSON 강제
    }
  };

  // ... Dio Post & Parse Logic ...
}
```

### B. Gemini Image Repository Implementation
`gemini-3-pro-image-preview` 호출 시 `responseModalities` 설정과 Base64 디코딩이 필수입니다.

```dart
// Reference: data/repositories/gemini_image_repository.dart
Future<Uint8List?> generateImage({
  required String prompt,
  String? referenceBase64, // 편집 모드일 경우 사용
}) async {
  final url = '$_baseUrl/gemini-3-pro-image-preview:generateContent?key=$_apiKey';
  
  final List<Map<String, dynamic>> parts = [{"text": prompt}];

  // [EDIT MODE] 기존 이미지를 inline_data로 첨부하여 편집 요청
  if (referenceBase64 != null) {
    parts.add({
      "inline_data": {
        "mime_type": "image/png",
        "data": referenceBase64
      }
    });
  }

  final body = {
    "contents": [{"parts": parts}],
    "generationConfig": {
      "responseModalities": ["TEXT", "IMAGE"], // 필수
      "imageConfig": {
        "aspectRatio": "16:9",
        "imageSize": "2K"
      }
    }
  };

  // ... Dio Post -> Parse 'inlineData' -> base64Decode ...
}
```

---

## 4. 🔄 Data Flow (Lifecycle)

1.  **User Input**: 유저가 액션(버튼/텍스트)을 수행.
2.  **Logic (Fast)**:
    *   `gemini-2.5-flash`가 상황을 판단하고 JSON을 반환.
    *   JSON에는 `story_text`, `ui_components`, 그리고 **`image_prompt`**가 포함됨.
    *   응답에 포함된 `thought_signature`를 로컬 DB/State에 저장.
3.  **UI Render**: GenUI가 JSON을 파싱하여 즉시 텍스트와 UI를 그임. (이미지 영역은 Loading).
4.  **Image Gen (Async)**:
    *   `GameViewModel`이 `image_prompt` 유무를 확인.
    *   `gemini-3-pro`에게 프롬프트(필요 시 이전 이미지 포함)를 전송.
    *   Base64 이미지를 받아 `MemoryImage`로 변환 후 UI에 FadeIn 업데이트.

---

## 5. 💡 Key Features & Wow Points

코드를 작성할 때 아래 기능들의 구현을 우선순위에 둡니다.

1.  **동적 인벤토리 (Dynamic Inventory)**: "가방 열어" 요청 시, 텍스트 리스트가 아닌 실제 아이템들이 담긴 가방 내부 이미지를 생성.
2.  **텍스트 렌더링 (Text Rendering)**: 표지판, 현상수배지(Wanted Poster) 등에 정확한 글자 렌더링.
3.  **지도 생성 (Generative Map)**: 유저의 이동 경로 로그를 기반으로 낡은 지도 이미지를 생성.
4.  **논리적 편집 (Reasoning Editing)**: 횃불을 켜면 어두운 동굴 이미지를 밝게 수정(Re-drawing이 아닌 Editing).

---

**Instruction**: 모든 코드는 위 아키텍처와 REST API 규칙을 준수하여 작성하십시오. 주석을 충실히 달고, 에러 처리(Try-Catch)를 명확히 하십시오.
