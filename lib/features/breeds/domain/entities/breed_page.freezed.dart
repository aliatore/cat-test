// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breed_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BreedPage {

 List<Breed> get breeds; int get page; int get lastPage; int get total; DataOrigin get origin;/// Cuando se obtuvo de la API (para cache, cuando se guardo).
 DateTime get updatedAt;/// La cache ya paso su TTL: se muestra, pero hay que revalidar.
 bool get isStale;
/// Create a copy of BreedPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedPageCopyWith<BreedPage> get copyWith => _$BreedPageCopyWithImpl<BreedPage>(this as BreedPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedPage&&const DeepCollectionEquality().equals(other.breeds, breeds)&&(identical(other.page, page) || other.page == page)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isStale, isStale) || other.isStale == isStale));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(breeds),page,lastPage,total,origin,updatedAt,isStale);

@override
String toString() {
  return 'BreedPage(breeds: $breeds, page: $page, lastPage: $lastPage, total: $total, origin: $origin, updatedAt: $updatedAt, isStale: $isStale)';
}


}

/// @nodoc
abstract mixin class $BreedPageCopyWith<$Res>  {
  factory $BreedPageCopyWith(BreedPage value, $Res Function(BreedPage) _then) = _$BreedPageCopyWithImpl;
@useResult
$Res call({
 List<Breed> breeds, int page, int lastPage, int total, DataOrigin origin, DateTime updatedAt, bool isStale
});




}
/// @nodoc
class _$BreedPageCopyWithImpl<$Res>
    implements $BreedPageCopyWith<$Res> {
  _$BreedPageCopyWithImpl(this._self, this._then);

  final BreedPage _self;
  final $Res Function(BreedPage) _then;

/// Create a copy of BreedPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? breeds = null,Object? page = null,Object? lastPage = null,Object? total = null,Object? origin = null,Object? updatedAt = null,Object? isStale = null,}) {
  return _then(_self.copyWith(
breeds: null == breeds ? _self.breeds : breeds // ignore: cast_nullable_to_non_nullable
as List<Breed>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as DataOrigin,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isStale: null == isStale ? _self.isStale : isStale // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BreedPage].
extension BreedPagePatterns on BreedPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedPage value)  $default,){
final _that = this;
switch (_that) {
case _BreedPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedPage value)?  $default,){
final _that = this;
switch (_that) {
case _BreedPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Breed> breeds,  int page,  int lastPage,  int total,  DataOrigin origin,  DateTime updatedAt,  bool isStale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedPage() when $default != null:
return $default(_that.breeds,_that.page,_that.lastPage,_that.total,_that.origin,_that.updatedAt,_that.isStale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Breed> breeds,  int page,  int lastPage,  int total,  DataOrigin origin,  DateTime updatedAt,  bool isStale)  $default,) {final _that = this;
switch (_that) {
case _BreedPage():
return $default(_that.breeds,_that.page,_that.lastPage,_that.total,_that.origin,_that.updatedAt,_that.isStale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Breed> breeds,  int page,  int lastPage,  int total,  DataOrigin origin,  DateTime updatedAt,  bool isStale)?  $default,) {final _that = this;
switch (_that) {
case _BreedPage() when $default != null:
return $default(_that.breeds,_that.page,_that.lastPage,_that.total,_that.origin,_that.updatedAt,_that.isStale);case _:
  return null;

}
}

}

/// @nodoc


class _BreedPage extends BreedPage {
  const _BreedPage({required final  List<Breed> breeds, required this.page, required this.lastPage, required this.total, required this.origin, required this.updatedAt, this.isStale = false}): _breeds = breeds,super._();
  

 final  List<Breed> _breeds;
@override List<Breed> get breeds {
  if (_breeds is EqualUnmodifiableListView) return _breeds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_breeds);
}

@override final  int page;
@override final  int lastPage;
@override final  int total;
@override final  DataOrigin origin;
/// Cuando se obtuvo de la API (para cache, cuando se guardo).
@override final  DateTime updatedAt;
/// La cache ya paso su TTL: se muestra, pero hay que revalidar.
@override@JsonKey() final  bool isStale;

/// Create a copy of BreedPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedPageCopyWith<_BreedPage> get copyWith => __$BreedPageCopyWithImpl<_BreedPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedPage&&const DeepCollectionEquality().equals(other._breeds, _breeds)&&(identical(other.page, page) || other.page == page)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isStale, isStale) || other.isStale == isStale));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_breeds),page,lastPage,total,origin,updatedAt,isStale);

@override
String toString() {
  return 'BreedPage(breeds: $breeds, page: $page, lastPage: $lastPage, total: $total, origin: $origin, updatedAt: $updatedAt, isStale: $isStale)';
}


}

/// @nodoc
abstract mixin class _$BreedPageCopyWith<$Res> implements $BreedPageCopyWith<$Res> {
  factory _$BreedPageCopyWith(_BreedPage value, $Res Function(_BreedPage) _then) = __$BreedPageCopyWithImpl;
@override @useResult
$Res call({
 List<Breed> breeds, int page, int lastPage, int total, DataOrigin origin, DateTime updatedAt, bool isStale
});




}
/// @nodoc
class __$BreedPageCopyWithImpl<$Res>
    implements _$BreedPageCopyWith<$Res> {
  __$BreedPageCopyWithImpl(this._self, this._then);

  final _BreedPage _self;
  final $Res Function(_BreedPage) _then;

/// Create a copy of BreedPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? breeds = null,Object? page = null,Object? lastPage = null,Object? total = null,Object? origin = null,Object? updatedAt = null,Object? isStale = null,}) {
  return _then(_BreedPage(
breeds: null == breeds ? _self._breeds : breeds // ignore: cast_nullable_to_non_nullable
as List<Breed>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as DataOrigin,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isStale: null == isStale ? _self.isStale : isStale // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
