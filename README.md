# 🏛️ Infinite Dungeon with GenUI

**Infinite Dungeon** is a fully generative RPG built with **Flutter** and **Google Gemini API**.
Every aspect of the game—from the narrative and logic to the UI components and visual assets—is generated on the fly.

- **Game Logic**: Powered by `gemini-2.5-flash`
- **Visuals**: Rendered by `gemini-3-pro-image-preview`
- **UI Engine**: Dynamically constructed using `flutter_genui`

---

## 🏗️ Tech Stack & Architecture

- **Framework**: Flutter (Latest Stable)
- **Language**: Dart
- **Architecture**: Hybrid MVVM (Compass Style)
- **State Management**: **Riverpod** (Notifier / AsyncNotifier)
- **Networking**: **Dio** (Strict REST API Mode - No Client SDK)
- **Env Management**: `flutter_dotenv`
- **Serialization**: Freezed & JsonSerializable
- **UI Engine**: `flutter_genui` (JSON-based UI generation)

---

## 🤖 AI Model Strategy

### Role 1: Game Master (Logic & Text)
- **Model**: `gemini-2.5-flash`
- **Responsibility**:
  - Manages game progression and success/failure logic.
  - Generates **JSON data** strictly adhering to `flutter_genui` specs.
  - Crafts detailed `image_prompt`s for the visual renderer.
  - Maintains complex reasoning context via `thought_signature`.

### Role 2: Visual Renderer (Nano Banana Pro)
- **Model**: `gemini-3-pro-image-preview`
- **Responsibility**:
  - Renders high-quality scenes with accurate text (e.g., signboards).
  - Maintains character consistency.
  - Performs **Reasoning-based Editing** (e.g., lighting a torch modifies the existing dark cave image rather than redrawing it from scratch).

---

## 🚀 Getting Started

### 1. Environment Setup
Create a `.env` file in the root directory. You will need a Google Gemini API key.

```env
GEMINI_API_KEY=your_api_key_here
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run Code Generation
This project uses `freezed` and `json_serializable`. Run the build runner to generate necessary files.

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run the App
```bash
flutter run
```

---

## 📂 Project Structure

```text
lib/
├── config/                 # .env, theme configuration
├── domain/models/
│   ├── game_state.dart     # Freezed Data Class for game state
│   └── chat_message.dart   # Includes 'thought_signature' for context
├── data/repositories/
│   ├── gemini_logic_repository.dart  # Handles interactions with gemini-2.5-flash
│   └── gemini_image_repository.dart  # Handles interactions with gemini-3-pro
└── ui/
    ├── core/genui/         # GenUI Catalog & Schema definitions
    └── game/
        ├── view_model/     # GameViewModel (Riverpod)
        ├── widgets/        # Custom Widgets
        └── game_screen.dart
```

---

## 💡 Key Features

1.  **Dynamic Inventory**: Request to "open bag" generates a visual representation of the inventory items, not just text.
2.  **Accurate Text Rendering**: Generates images with legible text on signposts, wanted posters, and documents.
3.  **Generative Map**: Creates visual maps based on the user's movement logs.
4.  **Reasoning Editing**: Supports context-aware image editing (e.g., "turn on the light" illuminates the current scene).

---

## 📜 License

[MIT License](LICENSE)
