// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breed_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BreedDto {

 String get breed; String get country; String get origin; String get coat; String get pattern;
/// Create a copy of BreedDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedDtoCopyWith<BreedDto> get copyWith => _$BreedDtoCopyWithImpl<BreedDto>(this as BreedDto, _$identity);

  /// Serializes this BreedDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedDto&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.country, country) || other.country == country)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.coat, coat) || other.coat == coat)&&(identical(other.pattern, pattern) || other.pattern == pattern));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,breed,country,origin,coat,pattern);

@override
String toString() {
  return 'BreedDto(breed: $breed, country: $country, origin: $origin, coat: $coat, pattern: $pattern)';
}


}

/// @nodoc
abstract mixin class $BreedDtoCopyWith<$Res>  {
  factory $BreedDtoCopyWith(BreedDto value, $Res Function(BreedDto) _then) = _$BreedDtoCopyWithImpl;
@useResult
$Res call({
 String breed, String country, String origin, String coat, String pattern
});




}
/// @nodoc
class _$BreedDtoCopyWithImpl<$Res>
    implements $BreedDtoCopyWith<$Res> {
  _$BreedDtoCopyWithImpl(this._self, this._then);

  final BreedDto _self;
  final $Res Function(BreedDto) _then;

/// Create a copy of BreedDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? breed = null,Object? country = null,Object? origin = null,Object? coat = null,Object? pattern = null,}) {
  return _then(_self.copyWith(
breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,coat: null == coat ? _self.coat : coat // ignore: cast_nullable_to_non_nullable
as String,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BreedDto].
extension BreedDtoPatterns on BreedDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedDto value)  $default,){
final _that = this;
switch (_that) {
case _BreedDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedDto value)?  $default,){
final _that = this;
switch (_that) {
case _BreedDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String breed,  String country,  String origin,  String coat,  String pattern)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedDto() when $default != null:
return $default(_that.breed,_that.country,_that.origin,_that.coat,_that.pattern);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String breed,  String country,  String origin,  String coat,  String pattern)  $default,) {final _that = this;
switch (_that) {
case _BreedDto():
return $default(_that.breed,_that.country,_that.origin,_that.coat,_that.pattern);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String breed,  String country,  String origin,  String coat,  String pattern)?  $default,) {final _that = this;
switch (_that) {
case _BreedDto() when $default != null:
return $default(_that.breed,_that.country,_that.origin,_that.coat,_that.pattern);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreedDto implements BreedDto {
  const _BreedDto({this.breed = '', this.country = '', this.origin = '', this.coat = '', this.pattern = ''});
  factory _BreedDto.fromJson(Map<String, dynamic> json) => _$BreedDtoFromJson(json);

@override@JsonKey() final  String breed;
@override@JsonKey() final  String country;
@override@JsonKey() final  String origin;
@override@JsonKey() final  String coat;
@override@JsonKey() final  String pattern;

/// Create a copy of BreedDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedDtoCopyWith<_BreedDto> get copyWith => __$BreedDtoCopyWithImpl<_BreedDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreedDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedDto&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.country, country) || other.country == country)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.coat, coat) || other.coat == coat)&&(identical(other.pattern, pattern) || other.pattern == pattern));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,breed,country,origin,coat,pattern);

@override
String toString() {
  return 'BreedDto(breed: $breed, country: $country, origin: $origin, coat: $coat, pattern: $pattern)';
}


}

/// @nodoc
abstract mixin class _$BreedDtoCopyWith<$Res> implements $BreedDtoCopyWith<$Res> {
  factory _$BreedDtoCopyWith(_BreedDto value, $Res Function(_BreedDto) _then) = __$BreedDtoCopyWithImpl;
@override @useResult
$Res call({
 String breed, String country, String origin, String coat, String pattern
});




}
/// @nodoc
class __$BreedDtoCopyWithImpl<$Res>
    implements _$BreedDtoCopyWith<$Res> {
  __$BreedDtoCopyWithImpl(this._self, this._then);

  final _BreedDto _self;
  final $Res Function(_BreedDto) _then;

/// Create a copy of BreedDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? breed = null,Object? country = null,Object? origin = null,Object? coat = null,Object? pattern = null,}) {
  return _then(_BreedDto(
breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,coat: null == coat ? _self.coat : coat // ignore: cast_nullable_to_non_nullable
as String,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BreedsPageDto {

@JsonKey(fromJson: readInt) int get currentPage;@JsonKey(fromJson: readInt) int get lastPage;@JsonKey(fromJson: readInt) int get perPage;@JsonKey(fromJson: readInt) int get total; List<BreedDto> get data;
/// Create a copy of BreedsPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedsPageDtoCopyWith<BreedsPageDto> get copyWith => _$BreedsPageDtoCopyWithImpl<BreedsPageDto>(this as BreedsPageDto, _$identity);

  /// Serializes this BreedsPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedsPageDto&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'BreedsPageDto(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, data: $data)';
}


}

/// @nodoc
abstract mixin class $BreedsPageDtoCopyWith<$Res>  {
  factory $BreedsPageDtoCopyWith(BreedsPageDto value, $Res Function(BreedsPageDto) _then) = _$BreedsPageDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: readInt) int currentPage,@JsonKey(fromJson: readInt) int lastPage,@JsonKey(fromJson: readInt) int perPage,@JsonKey(fromJson: readInt) int total, List<BreedDto> data
});




}
/// @nodoc
class _$BreedsPageDtoCopyWithImpl<$Res>
    implements $BreedsPageDtoCopyWith<$Res> {
  _$BreedsPageDtoCopyWithImpl(this._self, this._then);

  final BreedsPageDto _self;
  final $Res Function(BreedsPageDto) _then;

/// Create a copy of BreedsPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,Object? data = null,}) {
  return _then(_self.copyWith(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<BreedDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [BreedsPageDto].
extension BreedsPageDtoPatterns on BreedsPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedsPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedsPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedsPageDto value)  $default,){
final _that = this;
switch (_that) {
case _BreedsPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedsPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _BreedsPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: readInt)  int currentPage, @JsonKey(fromJson: readInt)  int lastPage, @JsonKey(fromJson: readInt)  int perPage, @JsonKey(fromJson: readInt)  int total,  List<BreedDto> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedsPageDto() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: readInt)  int currentPage, @JsonKey(fromJson: readInt)  int lastPage, @JsonKey(fromJson: readInt)  int perPage, @JsonKey(fromJson: readInt)  int total,  List<BreedDto> data)  $default,) {final _that = this;
switch (_that) {
case _BreedsPageDto():
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: readInt)  int currentPage, @JsonKey(fromJson: readInt)  int lastPage, @JsonKey(fromJson: readInt)  int perPage, @JsonKey(fromJson: readInt)  int total,  List<BreedDto> data)?  $default,) {final _that = this;
switch (_that) {
case _BreedsPageDto() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreedsPageDto implements BreedsPageDto {
  const _BreedsPageDto({@JsonKey(fromJson: readInt) required this.currentPage, @JsonKey(fromJson: readInt) required this.lastPage, @JsonKey(fromJson: readInt) required this.perPage, @JsonKey(fromJson: readInt) required this.total, final  List<BreedDto> data = const <BreedDto>[]}): _data = data;
  factory _BreedsPageDto.fromJson(Map<String, dynamic> json) => _$BreedsPageDtoFromJson(json);

@override@JsonKey(fromJson: readInt) final  int currentPage;
@override@JsonKey(fromJson: readInt) final  int lastPage;
@override@JsonKey(fromJson: readInt) final  int perPage;
@override@JsonKey(fromJson: readInt) final  int total;
 final  List<BreedDto> _data;
@override@JsonKey() List<BreedDto> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of BreedsPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedsPageDtoCopyWith<_BreedsPageDto> get copyWith => __$BreedsPageDtoCopyWithImpl<_BreedsPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreedsPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedsPageDto&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'BreedsPageDto(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, data: $data)';
}


}

/// @nodoc
abstract mixin class _$BreedsPageDtoCopyWith<$Res> implements $BreedsPageDtoCopyWith<$Res> {
  factory _$BreedsPageDtoCopyWith(_BreedsPageDto value, $Res Function(_BreedsPageDto) _then) = __$BreedsPageDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: readInt) int currentPage,@JsonKey(fromJson: readInt) int lastPage,@JsonKey(fromJson: readInt) int perPage,@JsonKey(fromJson: readInt) int total, List<BreedDto> data
});




}
/// @nodoc
class __$BreedsPageDtoCopyWithImpl<$Res>
    implements _$BreedsPageDtoCopyWith<$Res> {
  __$BreedsPageDtoCopyWithImpl(this._self, this._then);

  final _BreedsPageDto _self;
  final $Res Function(_BreedsPageDto) _then;

/// Create a copy of BreedsPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,Object? data = null,}) {
  return _then(_BreedsPageDto(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<BreedDto>,
  ));
}


}

// dart format on
