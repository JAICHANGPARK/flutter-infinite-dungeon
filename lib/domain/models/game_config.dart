import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_config.freezed.dart';
part 'game_config.g.dart';

@freezed
abstract class GameConfig with _$GameConfig {
  const factory GameConfig({
    @Default('') String apiKey,
    @Default('Hero') String characterName,
    @Default('Adventurer') String characterClass,
  }) = _GameConfig;

  factory GameConfig.fromJson(Map<String, dynamic> json) =>
      _$GameConfigFromJson(json);
}
