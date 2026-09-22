// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breeds_cache_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BreedsCacheInfo {

 int get pages; int get breeds; DateTime? get lastUpdated;
/// Create a copy of BreedsCacheInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedsCacheInfoCopyWith<BreedsCacheInfo> get copyWith => _$BreedsCacheInfoCopyWithImpl<BreedsCacheInfo>(this as BreedsCacheInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedsCacheInfo&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.breeds, breeds) || other.breeds == breeds)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,pages,breeds,lastUpdated);

@override
String toString() {
  return 'BreedsCacheInfo(pages: $pages, breeds: $breeds, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $BreedsCacheInfoCopyWith<$Res>  {
  factory $BreedsCacheInfoCopyWith(BreedsCacheInfo value, $Res Function(BreedsCacheInfo) _then) = _$BreedsCacheInfoCopyWithImpl;
@useResult
$Res call({
 int pages, int breeds, DateTime? lastUpdated
});




}
/// @nodoc
class _$BreedsCacheInfoCopyWithImpl<$Res>
    implements $BreedsCacheInfoCopyWith<$Res> {
  _$BreedsCacheInfoCopyWithImpl(this._self, this._then);

  final BreedsCacheInfo _self;
  final $Res Function(BreedsCacheInfo) _then;

/// Create a copy of BreedsCacheInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pages = null,Object? breeds = null,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,breeds: null == breeds ? _self.breeds : breeds // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BreedsCacheInfo].
extension BreedsCacheInfoPatterns on BreedsCacheInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedsCacheInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedsCacheInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedsCacheInfo value)  $default,){
final _that = this;
switch (_that) {
case _BreedsCacheInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedsCacheInfo value)?  $default,){
final _that = this;
switch (_that) {
case _BreedsCacheInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pages,  int breeds,  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedsCacheInfo() when $default != null:
return $default(_that.pages,_that.breeds,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pages,  int breeds,  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _BreedsCacheInfo():
return $default(_that.pages,_that.breeds,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pages,  int breeds,  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _BreedsCacheInfo() when $default != null:
return $default(_that.pages,_that.breeds,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc


class _BreedsCacheInfo implements BreedsCacheInfo {
  const _BreedsCacheInfo({required this.pages, required this.breeds, this.lastUpdated});
  

@override final  int pages;
@override final  int breeds;
@override final  DateTime? lastUpdated;

/// Create a copy of BreedsCacheInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedsCacheInfoCopyWith<_BreedsCacheInfo> get copyWith => __$BreedsCacheInfoCopyWithImpl<_BreedsCacheInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedsCacheInfo&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.breeds, breeds) || other.breeds == breeds)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,pages,breeds,lastUpdated);

@override
String toString() {
  return 'BreedsCacheInfo(pages: $pages, breeds: $breeds, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$BreedsCacheInfoCopyWith<$Res> implements $BreedsCacheInfoCopyWith<$Res> {
  factory _$BreedsCacheInfoCopyWith(_BreedsCacheInfo value, $Res Function(_BreedsCacheInfo) _then) = __$BreedsCacheInfoCopyWithImpl;
@override @useResult
$Res call({
 int pages, int breeds, DateTime? lastUpdated
});




}
/// @nodoc
class __$BreedsCacheInfoCopyWithImpl<$Res>
    implements _$BreedsCacheInfoCopyWith<$Res> {
  __$BreedsCacheInfoCopyWithImpl(this._self, this._then);

  final _BreedsCacheInfo _self;
  final $Res Function(_BreedsCacheInfo) _then;

/// Create a copy of BreedsCacheInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pages = null,Object? breeds = null,Object? lastUpdated = freezed,}) {
  return _then(_BreedsCacheInfo(
pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,breeds: null == breeds ? _self.breeds : breeds // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
