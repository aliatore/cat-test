// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Breed {

 String get name; String? get country; String? get origin; String? get coat; String? get pattern;
/// Create a copy of Breed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedCopyWith<Breed> get copyWith => _$BreedCopyWithImpl<Breed>(this as Breed, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Breed&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.coat, coat) || other.coat == coat)&&(identical(other.pattern, pattern) || other.pattern == pattern));
}


@override
int get hashCode => Object.hash(runtimeType,name,country,origin,coat,pattern);

@override
String toString() {
  return 'Breed(name: $name, country: $country, origin: $origin, coat: $coat, pattern: $pattern)';
}


}

/// @nodoc
abstract mixin class $BreedCopyWith<$Res>  {
  factory $BreedCopyWith(Breed value, $Res Function(Breed) _then) = _$BreedCopyWithImpl;
@useResult
$Res call({
 String name, String? country, String? origin, String? coat, String? pattern
});




}
/// @nodoc
class _$BreedCopyWithImpl<$Res>
    implements $BreedCopyWith<$Res> {
  _$BreedCopyWithImpl(this._self, this._then);

  final Breed _self;
  final $Res Function(Breed) _then;

/// Create a copy of Breed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? country = freezed,Object? origin = freezed,Object? coat = freezed,Object? pattern = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,coat: freezed == coat ? _self.coat : coat // ignore: cast_nullable_to_non_nullable
as String?,pattern: freezed == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Breed].
extension BreedPatterns on Breed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Breed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Breed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Breed value)  $default,){
final _that = this;
switch (_that) {
case _Breed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Breed value)?  $default,){
final _that = this;
switch (_that) {
case _Breed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? country,  String? origin,  String? coat,  String? pattern)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Breed() when $default != null:
return $default(_that.name,_that.country,_that.origin,_that.coat,_that.pattern);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? country,  String? origin,  String? coat,  String? pattern)  $default,) {final _that = this;
switch (_that) {
case _Breed():
return $default(_that.name,_that.country,_that.origin,_that.coat,_that.pattern);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? country,  String? origin,  String? coat,  String? pattern)?  $default,) {final _that = this;
switch (_that) {
case _Breed() when $default != null:
return $default(_that.name,_that.country,_that.origin,_that.coat,_that.pattern);case _:
  return null;

}
}

}

/// @nodoc


class _Breed extends Breed {
  const _Breed({required this.name, this.country, this.origin, this.coat, this.pattern}): super._();
  

@override final  String name;
@override final  String? country;
@override final  String? origin;
@override final  String? coat;
@override final  String? pattern;

/// Create a copy of Breed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedCopyWith<_Breed> get copyWith => __$BreedCopyWithImpl<_Breed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Breed&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.coat, coat) || other.coat == coat)&&(identical(other.pattern, pattern) || other.pattern == pattern));
}


@override
int get hashCode => Object.hash(runtimeType,name,country,origin,coat,pattern);

@override
String toString() {
  return 'Breed(name: $name, country: $country, origin: $origin, coat: $coat, pattern: $pattern)';
}


}

/// @nodoc
abstract mixin class _$BreedCopyWith<$Res> implements $BreedCopyWith<$Res> {
  factory _$BreedCopyWith(_Breed value, $Res Function(_Breed) _then) = __$BreedCopyWithImpl;
@override @useResult
$Res call({
 String name, String? country, String? origin, String? coat, String? pattern
});




}
/// @nodoc
class __$BreedCopyWithImpl<$Res>
    implements _$BreedCopyWith<$Res> {
  __$BreedCopyWithImpl(this._self, this._then);

  final _Breed _self;
  final $Res Function(_Breed) _then;

/// Create a copy of Breed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? country = freezed,Object? origin = freezed,Object? coat = freezed,Object? pattern = freezed,}) {
  return _then(_Breed(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,coat: freezed == coat ? _self.coat : coat // ignore: cast_nullable_to_non_nullable
as String?,pattern: freezed == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
