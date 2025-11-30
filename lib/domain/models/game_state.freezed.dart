// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameState implements DiagnosticableTreeMixin {

 List<ChatMessage> get history; bool get isGeneratingText; bool get isGeneratingImage; List<GameTurn> get turns; int get currentTurnIndex;@Uint8ListConverter() Uint8List? get currentImage; String? get currentImagePrompt;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GameState'))
    ..add(DiagnosticsProperty('history', history))..add(DiagnosticsProperty('isGeneratingText', isGeneratingText))..add(DiagnosticsProperty('isGeneratingImage', isGeneratingImage))..add(DiagnosticsProperty('turns', turns))..add(DiagnosticsProperty('currentTurnIndex', currentTurnIndex))..add(DiagnosticsProperty('currentImage', currentImage))..add(DiagnosticsProperty('currentImagePrompt', currentImagePrompt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.isGeneratingText, isGeneratingText) || other.isGeneratingText == isGeneratingText)&&(identical(other.isGeneratingImage, isGeneratingImage) || other.isGeneratingImage == isGeneratingImage)&&const DeepCollectionEquality().equals(other.turns, turns)&&(identical(other.currentTurnIndex, currentTurnIndex) || other.currentTurnIndex == currentTurnIndex)&&const DeepCollectionEquality().equals(other.currentImage, currentImage)&&(identical(other.currentImagePrompt, currentImagePrompt) || other.currentImagePrompt == currentImagePrompt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(history),isGeneratingText,isGeneratingImage,const DeepCollectionEquality().hash(turns),currentTurnIndex,const DeepCollectionEquality().hash(currentImage),currentImagePrompt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GameState(history: $history, isGeneratingText: $isGeneratingText, isGeneratingImage: $isGeneratingImage, turns: $turns, currentTurnIndex: $currentTurnIndex, currentImage: $currentImage, currentImagePrompt: $currentImagePrompt)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> history, bool isGeneratingText, bool isGeneratingImage, List<GameTurn> turns, int currentTurnIndex,@Uint8ListConverter() Uint8List? currentImage, String? currentImagePrompt
});




}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? history = null,Object? isGeneratingText = null,Object? isGeneratingImage = null,Object? turns = null,Object? currentTurnIndex = null,Object? currentImage = freezed,Object? currentImagePrompt = freezed,}) {
  return _then(_self.copyWith(
history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,isGeneratingText: null == isGeneratingText ? _self.isGeneratingText : isGeneratingText // ignore: cast_nullable_to_non_nullable
as bool,isGeneratingImage: null == isGeneratingImage ? _self.isGeneratingImage : isGeneratingImage // ignore: cast_nullable_to_non_nullable
as bool,turns: null == turns ? _self.turns : turns // ignore: cast_nullable_to_non_nullable
as List<GameTurn>,currentTurnIndex: null == currentTurnIndex ? _self.currentTurnIndex : currentTurnIndex // ignore: cast_nullable_to_non_nullable
as int,currentImage: freezed == currentImage ? _self.currentImage : currentImage // ignore: cast_nullable_to_non_nullable
as Uint8List?,currentImagePrompt: freezed == currentImagePrompt ? _self.currentImagePrompt : currentImagePrompt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatMessage> history,  bool isGeneratingText,  bool isGeneratingImage,  List<GameTurn> turns,  int currentTurnIndex, @Uint8ListConverter()  Uint8List? currentImage,  String? currentImagePrompt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.history,_that.isGeneratingText,_that.isGeneratingImage,_that.turns,_that.currentTurnIndex,_that.currentImage,_that.currentImagePrompt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatMessage> history,  bool isGeneratingText,  bool isGeneratingImage,  List<GameTurn> turns,  int currentTurnIndex, @Uint8ListConverter()  Uint8List? currentImage,  String? currentImagePrompt)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.history,_that.isGeneratingText,_that.isGeneratingImage,_that.turns,_that.currentTurnIndex,_that.currentImage,_that.currentImagePrompt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatMessage> history,  bool isGeneratingText,  bool isGeneratingImage,  List<GameTurn> turns,  int currentTurnIndex, @Uint8ListConverter()  Uint8List? currentImage,  String? currentImagePrompt)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.history,_that.isGeneratingText,_that.isGeneratingImage,_that.turns,_that.currentTurnIndex,_that.currentImage,_that.currentImagePrompt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameState with DiagnosticableTreeMixin implements GameState {
  const _GameState({final  List<ChatMessage> history = const [], this.isGeneratingText = false, this.isGeneratingImage = false, final  List<GameTurn> turns = const [], this.currentTurnIndex = 0, @Uint8ListConverter() this.currentImage, this.currentImagePrompt}): _history = history,_turns = turns;
  factory _GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

 final  List<ChatMessage> _history;
@override@JsonKey() List<ChatMessage> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override@JsonKey() final  bool isGeneratingText;
@override@JsonKey() final  bool isGeneratingImage;
 final  List<GameTurn> _turns;
@override@JsonKey() List<GameTurn> get turns {
  if (_turns is EqualUnmodifiableListView) return _turns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_turns);
}

@override@JsonKey() final  int currentTurnIndex;
@override@Uint8ListConverter() final  Uint8List? currentImage;
@override final  String? currentImagePrompt;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GameState'))
    ..add(DiagnosticsProperty('history', history))..add(DiagnosticsProperty('isGeneratingText', isGeneratingText))..add(DiagnosticsProperty('isGeneratingImage', isGeneratingImage))..add(DiagnosticsProperty('turns', turns))..add(DiagnosticsProperty('currentTurnIndex', currentTurnIndex))..add(DiagnosticsProperty('currentImage', currentImage))..add(DiagnosticsProperty('currentImagePrompt', currentImagePrompt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.isGeneratingText, isGeneratingText) || other.isGeneratingText == isGeneratingText)&&(identical(other.isGeneratingImage, isGeneratingImage) || other.isGeneratingImage == isGeneratingImage)&&const DeepCollectionEquality().equals(other._turns, _turns)&&(identical(other.currentTurnIndex, currentTurnIndex) || other.currentTurnIndex == currentTurnIndex)&&const DeepCollectionEquality().equals(other.currentImage, currentImage)&&(identical(other.currentImagePrompt, currentImagePrompt) || other.currentImagePrompt == currentImagePrompt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_history),isGeneratingText,isGeneratingImage,const DeepCollectionEquality().hash(_turns),currentTurnIndex,const DeepCollectionEquality().hash(currentImage),currentImagePrompt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GameState(history: $history, isGeneratingText: $isGeneratingText, isGeneratingImage: $isGeneratingImage, turns: $turns, currentTurnIndex: $currentTurnIndex, currentImage: $currentImage, currentImagePrompt: $currentImagePrompt)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 List<ChatMessage> history, bool isGeneratingText, bool isGeneratingImage, List<GameTurn> turns, int currentTurnIndex,@Uint8ListConverter() Uint8List? currentImage, String? currentImagePrompt
});




}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? history = null,Object? isGeneratingText = null,Object? isGeneratingImage = null,Object? turns = null,Object? currentTurnIndex = null,Object? currentImage = freezed,Object? currentImagePrompt = freezed,}) {
  return _then(_GameState(
history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,isGeneratingText: null == isGeneratingText ? _self.isGeneratingText : isGeneratingText // ignore: cast_nullable_to_non_nullable
as bool,isGeneratingImage: null == isGeneratingImage ? _self.isGeneratingImage : isGeneratingImage // ignore: cast_nullable_to_non_nullable
as bool,turns: null == turns ? _self._turns : turns // ignore: cast_nullable_to_non_nullable
as List<GameTurn>,currentTurnIndex: null == currentTurnIndex ? _self.currentTurnIndex : currentTurnIndex // ignore: cast_nullable_to_non_nullable
as int,currentImage: freezed == currentImage ? _self.currentImage : currentImage // ignore: cast_nullable_to_non_nullable
as Uint8List?,currentImagePrompt: freezed == currentImagePrompt ? _self.currentImagePrompt : currentImagePrompt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
