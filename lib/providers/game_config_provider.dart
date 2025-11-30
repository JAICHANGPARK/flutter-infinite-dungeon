import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/game_config.dart';

part 'game_config_provider.g.dart';

@Riverpod(keepAlive: true)
class GameConfigNotifier extends _$GameConfigNotifier {
  @override
  GameConfig build() {
    return const GameConfig();
  }

  void setApiKey(String apiKey) {
    state = state.copyWith(apiKey: apiKey);
  }

  void setCharacterName(String name) {
    state = state.copyWith(characterName: name);
  }

  void setCharacterClass(String charClass) {
    state = state.copyWith(characterClass: charClass);
  }
}
