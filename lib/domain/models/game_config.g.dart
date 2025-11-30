// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameConfig _$GameConfigFromJson(Map<String, dynamic> json) => _GameConfig(
  apiKey: json['apiKey'] as String? ?? '',
  characterName: json['characterName'] as String? ?? 'Hero',
  characterClass: json['characterClass'] as String? ?? 'Adventurer',
);

Map<String, dynamic> _$GameConfigToJson(_GameConfig instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'characterName': instance.characterName,
      'characterClass': instance.characterClass,
    };
