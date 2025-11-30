// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_turn.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameTurn {

 String get id; String get userAction; String get storyText; String? get imagePrompt;@Uint8ListConverter() Uint8List? get imageData; Map<String, dynamic> get statusSnapshot; String get thoughtSignature; DateTime get timestamp;
/// Create a copy of GameTurn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameTurnCopyWith<GameTurn> get copyWith => _$GameTurnCopyWithImpl<GameTurn>(this as GameTurn, _$identity);

  /// Serializes this GameTurn to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameTurn&&(identical(other.id, id) || other.id == id)&&(identical(other.userAction, userAction) || other.userAction == userAction)&&(identical(other.storyText, storyText) || other.storyText == storyText)&&(identical(other.imagePrompt, imagePrompt) || other.imagePrompt == imagePrompt)&&const DeepCollectionEquality().equals(other.imageData, imageData)&&const DeepCollectionEquality().equals(other.statusSnapshot, statusSnapshot)&&(identical(other.thoughtSignature, thoughtSignature) || other.thoughtSignature == thoughtSignature)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userAction,storyText,imagePrompt,const DeepCollectionEquality().hash(imageData),const DeepCollectionEquality().hash(statusSnapshot),thoughtSignature,timestamp);

@override
String toString() {
  return 'GameTurn(id: $id, userAction: $userAction, storyText: $storyText, imagePrompt: $imagePrompt, imageData: $imageData, statusSnapshot: $statusSnapshot, thoughtSignature: $thoughtSignature, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $GameTurnCopyWith<$Res>  {
  factory $GameTurnCopyWith(GameTurn value, $Res Function(GameTurn) _then) = _$GameTurnCopyWithImpl;
@useResult
$Res call({
 String id, String userAction, String storyText, String? imagePrompt,@Uint8ListConverter() Uint8List? imageData, Map<String, dynamic> statusSnapshot, String thoughtSignature, DateTime timestamp
});




}
/// @nodoc
class _$GameTurnCopyWithImpl<$Res>
    implements $GameTurnCopyWith<$Res> {
  _$GameTurnCopyWithImpl(this._self, this._then);

  final GameTurn _self;
  final $Res Function(GameTurn) _then;

/// Create a copy of GameTurn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userAction = null,Object? storyText = null,Object? imagePrompt = freezed,Object? imageData = freezed,Object? statusSnapshot = null,Object? thoughtSignature = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userAction: null == userAction ? _self.userAction : userAction // ignore: cast_nullable_to_non_nullable
as String,storyText: null == storyText ? _self.storyText : storyText // ignore: cast_nullable_to_non_nullable
as String,imagePrompt: freezed == imagePrompt ? _self.imagePrompt : imagePrompt // ignore: cast_nullable_to_non_nullable
as String?,imageData: freezed == imageData ? _self.imageData : imageData // ignore: cast_nullable_to_non_nullable
as Uint8List?,statusSnapshot: null == statusSnapshot ? _self.statusSnapshot : statusSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,thoughtSignature: null == thoughtSignature ? _self.thoughtSignature : thoughtSignature // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GameTurn].
extension GameTurnPatterns on GameTurn {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameTurn value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameTurn() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameTurn value)  $default,){
final _that = this;
switch (_that) {
case _GameTurn():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameTurn value)?  $default,){
final _that = this;
switch (_that) {
case _GameTurn() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userAction,  String storyText,  String? imagePrompt, @Uint8ListConverter()  Uint8List? imageData,  Map<String, dynamic> statusSnapshot,  String thoughtSignature,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameTurn() when $default != null:
return $default(_that.id,_that.userAction,_that.storyText,_that.imagePrompt,_that.imageData,_that.statusSnapshot,_that.thoughtSignature,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userAction,  String storyText,  String? imagePrompt, @Uint8ListConverter()  Uint8List? imageData,  Map<String, dynamic> statusSnapshot,  String thoughtSignature,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _GameTurn():
return $default(_that.id,_that.userAction,_that.storyText,_that.imagePrompt,_that.imageData,_that.statusSnapshot,_that.thoughtSignature,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userAction,  String storyText,  String? imagePrompt, @Uint8ListConverter()  Uint8List? imageData,  Map<String, dynamic> statusSnapshot,  String thoughtSignature,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _GameTurn() when $default != null:
return $default(_that.id,_that.userAction,_that.storyText,_that.imagePrompt,_that.imageData,_that.statusSnapshot,_that.thoughtSignature,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameTurn implements GameTurn {
  const _GameTurn({required this.id, required this.userAction, required this.storyText, this.imagePrompt, @Uint8ListConverter() this.imageData, required final  Map<String, dynamic> statusSnapshot, required this.thoughtSignature, required this.timestamp}): _statusSnapshot = statusSnapshot;
  factory _GameTurn.fromJson(Map<String, dynamic> json) => _$GameTurnFromJson(json);

@override final  String id;
@override final  String userAction;
@override final  String storyText;
@override final  String? imagePrompt;
@override@Uint8ListConverter() final  Uint8List? imageData;
 final  Map<String, dynamic> _statusSnapshot;
@override Map<String, dynamic> get statusSnapshot {
  if (_statusSnapshot is EqualUnmodifiableMapView) return _statusSnapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statusSnapshot);
}

@override final  String thoughtSignature;
@override final  DateTime timestamp;

/// Create a copy of GameTurn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameTurnCopyWith<_GameTurn> get copyWith => __$GameTurnCopyWithImpl<_GameTurn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameTurnToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameTurn&&(identical(other.id, id) || other.id == id)&&(identical(other.userAction, userAction) || other.userAction == userAction)&&(identical(other.storyText, storyText) || other.storyText == storyText)&&(identical(other.imagePrompt, imagePrompt) || other.imagePrompt == imagePrompt)&&const DeepCollectionEquality().equals(other.imageData, imageData)&&const DeepCollectionEquality().equals(other._statusSnapshot, _statusSnapshot)&&(identical(other.thoughtSignature, thoughtSignature) || other.thoughtSignature == thoughtSignature)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userAction,storyText,imagePrompt,const DeepCollectionEquality().hash(imageData),const DeepCollectionEquality().hash(_statusSnapshot),thoughtSignature,timestamp);

@override
String toString() {
  return 'GameTurn(id: $id, userAction: $userAction, storyText: $storyText, imagePrompt: $imagePrompt, imageData: $imageData, statusSnapshot: $statusSnapshot, thoughtSignature: $thoughtSignature, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$GameTurnCopyWith<$Res> implements $GameTurnCopyWith<$Res> {
  factory _$GameTurnCopyWith(_GameTurn value, $Res Function(_GameTurn) _then) = __$GameTurnCopyWithImpl;
@override @useResult
$Res call({
 String id, String userAction, String storyText, String? imagePrompt,@Uint8ListConverter() Uint8List? imageData, Map<String, dynamic> statusSnapshot, String thoughtSignature, DateTime timestamp
});




}
/// @nodoc
class __$GameTurnCopyWithImpl<$Res>
    implements _$GameTurnCopyWith<$Res> {
  __$GameTurnCopyWithImpl(this._self, this._then);

  final _GameTurn _self;
  final $Res Function(_GameTurn) _then;

/// Create a copy of GameTurn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userAction = null,Object? storyText = null,Object? imagePrompt = freezed,Object? imageData = freezed,Object? statusSnapshot = null,Object? thoughtSignature = null,Object? timestamp = null,}) {
  return _then(_GameTurn(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userAction: null == userAction ? _self.userAction : userAction // ignore: cast_nullable_to_non_nullable
as String,storyText: null == storyText ? _self.storyText : storyText // ignore: cast_nullable_to_non_nullable
as String,imagePrompt: freezed == imagePrompt ? _self.imagePrompt : imagePrompt // ignore: cast_nullable_to_non_nullable
as String?,imageData: freezed == imageData ? _self.imageData : imageData // ignore: cast_nullable_to_non_nullable
as Uint8List?,statusSnapshot: null == statusSnapshot ? _self._statusSnapshot : statusSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,thoughtSignature: null == thoughtSignature ? _self.thoughtSignature : thoughtSignature // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
