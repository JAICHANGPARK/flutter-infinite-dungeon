// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameState _$GameStateFromJson(Map<String, dynamic> json) => _GameState(
  history:
      (json['history'] as List<dynamic>?)
          ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isGeneratingText: json['isGeneratingText'] as bool? ?? false,
  isGeneratingImage: json['isGeneratingImage'] as bool? ?? false,
  turns:
      (json['turns'] as List<dynamic>?)
          ?.map((e) => GameTurn.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  currentTurnIndex: (json['currentTurnIndex'] as num?)?.toInt() ?? 0,
  currentImage: const Uint8ListConverter().fromJson(
    json['currentImage'] as List<int>?,
  ),
  currentImagePrompt: json['currentImagePrompt'] as String?,
);

Map<String, dynamic> _$GameStateToJson(_GameState instance) =>
    <String, dynamic>{
      'history': instance.history,
      'isGeneratingText': instance.isGeneratingText,
      'isGeneratingImage': instance.isGeneratingImage,
      'turns': instance.turns,
      'currentTurnIndex': instance.currentTurnIndex,
      'currentImage': const Uint8ListConverter().toJson(instance.currentImage),
      'currentImagePrompt': instance.currentImagePrompt,
    };
