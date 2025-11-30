// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameConfigNotifier)
const gameConfigProvider = GameConfigNotifierProvider._();

final class GameConfigNotifierProvider
    extends $NotifierProvider<GameConfigNotifier, GameConfig> {
  const GameConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameConfigNotifierHash();

  @$internal
  @override
  GameConfigNotifier create() => GameConfigNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameConfig>(value),
    );
  }
}

String _$gameConfigNotifierHash() =>
    r'4ecdf6c1cd6806f4ece73d8a855d260aa89215b0';

abstract class _$GameConfigNotifier extends $Notifier<GameConfig> {
  GameConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GameConfig, GameConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameConfig, GameConfig>,
              GameConfig,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
