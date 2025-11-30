import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'chat_message.dart';
import 'game_turn.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    @Default([]) List<ChatMessage> history,
    @Default(false) bool isGeneratingText,
    @Default(false) bool isGeneratingImage,
    @Default([]) List<GameTurn> turns,
    @Default(0) int currentTurnIndex,
    @Uint8ListConverter() Uint8List? currentImage,
    String? currentImagePrompt,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}

class Uint8ListConverter implements JsonConverter<Uint8List?, List<int>?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List<int>? json) {
    if (json == null) return null;
    return Uint8List.fromList(json);
  }

  @override
  List<int>? toJson(Uint8List? object) {
    if (object == null) return null;
    return object.toList();
  }
}
