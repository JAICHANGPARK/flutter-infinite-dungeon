import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/game_state.dart';

/// Repository for saving and loading game state to/from local storage
class GameStateRepository {
  static const String _keyGameState = 'game_state';

  /// Save the current game state to local storage
  Future<void> saveGameState(GameState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert GameState to JSON
      final stateJson = state.toJson();

      // Convert Uint8List to base64 strings for storage
      final jsonString = jsonEncode(_encodeGameStateForStorage(stateJson));

      await prefs.setString(_keyGameState, jsonString);
    } catch (e) {
      debugPrint('[GameStateRepository] Error saving game state: $e');
    }
  }

  /// Load game state from local storage
  Future<GameState?> loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyGameState);

      if (jsonString == null) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final decodedJson = _decodeGameStateFromStorage(json);

      return GameState.fromJson(decodedJson);
    } catch (e) {
      debugPrint('[GameStateRepository] Error loading state: $e');
      return null;
    }
  }

  /// Clear saved game state
  Future<void> clearGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyGameState);
    } catch (e) {
      debugPrint('[GameStateRepository] Error clearing state: $e');
    }
  }

  /// Convert Uint8List fields to base64 strings for storage
  Map<String, dynamic> _encodeGameStateForStorage(Map<String, dynamic> json) {
    // Encode currentImage if present
    if (json['currentImage'] != null && json['currentImage'] is List) {
      final bytes = Uint8List.fromList(List<int>.from(json['currentImage']));
      json['currentImage'] = base64Encode(bytes);
    }

    // Encode image data in turns
    if (json['turns'] != null && json['turns'] is List) {
      json['turns'] = (json['turns'] as List).map((turn) {
        if (turn is Map<String, dynamic> && turn['imageData'] != null) {
          if (turn['imageData'] is List) {
            final bytes = Uint8List.fromList(List<int>.from(turn['imageData']));
            turn['imageData'] = base64Encode(bytes);
          }
        }
        return turn;
      }).toList();
    }

    // Encode history (no image data in history, but keep for consistency)
    return json;
  }

  /// Convert base64 strings back to Uint8List
  Map<String, dynamic> _decodeGameStateFromStorage(Map<String, dynamic> json) {
    // Decode currentImage if present
    if (json['currentImage'] != null && json['currentImage'] is String) {
      json['currentImage'] = base64Decode(json['currentImage']);
    }

    // Decode image data in turns
    if (json['turns'] != null && json['turns'] is List) {
      json['turns'] = (json['turns'] as List).map((turn) {
        if (turn is Map<String, dynamic> && turn['imageData'] != null) {
          if (turn['imageData'] is String) {
            turn['imageData'] = base64Decode(turn['imageData']);
          }
        }
        return turn;
      }).toList();
    }

    return json;
  }
}
