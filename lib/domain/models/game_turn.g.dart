// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_turn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameTurn _$GameTurnFromJson(Map<String, dynamic> json) => _GameTurn(
  id: json['id'] as String,
  userAction: json['userAction'] as String,
  storyText: json['storyText'] as String,
  imagePrompt: json['imagePrompt'] as String?,
  imageData: const Uint8ListConverter().fromJson(
    json['imageData'] as List<int>?,
  ),
  statusSnapshot: json['statusSnapshot'] as Map<String, dynamic>,
  thoughtSignature: json['thoughtSignature'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$GameTurnToJson(_GameTurn instance) => <String, dynamic>{
  'id': instance.id,
  'userAction': instance.userAction,
  'storyText': instance.storyText,
  'imagePrompt': instance.imagePrompt,
  'imageData': const Uint8ListConverter().toJson(instance.imageData),
  'statusSnapshot': instance.statusSnapshot,
  'thoughtSignature': instance.thoughtSignature,
  'timestamp': instance.timestamp.toIso8601String(),
};
