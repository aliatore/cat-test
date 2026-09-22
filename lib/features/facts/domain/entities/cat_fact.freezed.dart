// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cat_fact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatFact {

 String get text; DataOrigin get origin;
/// Create a copy of CatFact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatFactCopyWith<CatFact> get copyWith => _$CatFactCopyWithImpl<CatFact>(this as CatFact, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatFact&&(identical(other.text, text) || other.text == text)&&(identical(other.origin, origin) || other.origin == origin));
}


@override
int get hashCode => Object.hash(runtimeType,text,origin);

@override
String toString() {
  return 'CatFact(text: $text, origin: $origin)';
}


}

/// @nodoc
abstract mixin class $CatFactCopyWith<$Res>  {
  factory $CatFactCopyWith(CatFact value, $Res Function(CatFact) _then) = _$CatFactCopyWithImpl;
@useResult
$Res call({
 String text, DataOrigin origin
});




}
/// @nodoc
class _$CatFactCopyWithImpl<$Res>
    implements $CatFactCopyWith<$Res> {
  _$CatFactCopyWithImpl(this._self, this._then);

  final CatFact _self;
  final $Res Function(CatFact) _then;

/// Create a copy of CatFact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? origin = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as DataOrigin,
  ));
}

}


/// Adds pattern-matching-related methods to [CatFact].
extension CatFactPatterns on CatFact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatFact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatFact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatFact value)  $default,){
final _that = this;
switch (_that) {
case _CatFact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatFact value)?  $default,){
final _that = this;
switch (_that) {
case _CatFact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  DataOrigin origin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatFact() when $default != null:
return $default(_that.text,_that.origin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  DataOrigin origin)  $default,) {final _that = this;
switch (_that) {
case _CatFact():
return $default(_that.text,_that.origin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  DataOrigin origin)?  $default,) {final _that = this;
switch (_that) {
case _CatFact() when $default != null:
return $default(_that.text,_that.origin);case _:
  return null;

}
}

}

/// @nodoc


class _CatFact implements CatFact {
  const _CatFact({required this.text, required this.origin});
  

@override final  String text;
@override final  DataOrigin origin;

/// Create a copy of CatFact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatFactCopyWith<_CatFact> get copyWith => __$CatFactCopyWithImpl<_CatFact>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatFact&&(identical(other.text, text) || other.text == text)&&(identical(other.origin, origin) || other.origin == origin));
}


@override
int get hashCode => Object.hash(runtimeType,text,origin);

@override
String toString() {
  return 'CatFact(text: $text, origin: $origin)';
}


}

/// @nodoc
abstract mixin class _$CatFactCopyWith<$Res> implements $CatFactCopyWith<$Res> {
  factory _$CatFactCopyWith(_CatFact value, $Res Function(_CatFact) _then) = __$CatFactCopyWithImpl;
@override @useResult
$Res call({
 String text, DataOrigin origin
});




}
/// @nodoc
class __$CatFactCopyWithImpl<$Res>
    implements _$CatFactCopyWith<$Res> {
  __$CatFactCopyWithImpl(this._self, this._then);

  final _CatFact _self;
  final $Res Function(_CatFact) _then;

/// Create a copy of CatFact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? origin = null,}) {
  return _then(_CatFact(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as DataOrigin,
  ));
}


}

// dart format on
