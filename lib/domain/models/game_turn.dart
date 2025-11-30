import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_turn.freezed.dart';
part 'game_turn.g.dart';

@freezed
abstract class GameTurn with _$GameTurn {
  const factory GameTurn({
    required String id,
    required String userAction,
    required String storyText,
    String? imagePrompt,
    @Uint8ListConverter() Uint8List? imageData,
    required Map<String, dynamic> statusSnapshot,
    required String thoughtSignature,
    required DateTime timestamp,
  }) = _GameTurn;

  factory GameTurn.fromJson(Map<String, dynamic> json) =>
      _$GameTurnFromJson(json);
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
