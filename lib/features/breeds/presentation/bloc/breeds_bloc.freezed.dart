// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breeds_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BreedsNotice {

 int get id; BreedsNoticeKind get kind; Failure? get failure;
/// Create a copy of BreedsNotice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedsNoticeCopyWith<BreedsNotice> get copyWith => _$BreedsNoticeCopyWithImpl<BreedsNotice>(this as BreedsNotice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedsNotice&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,failure);

@override
String toString() {
  return 'BreedsNotice(id: $id, kind: $kind, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $BreedsNoticeCopyWith<$Res>  {
  factory $BreedsNoticeCopyWith(BreedsNotice value, $Res Function(BreedsNotice) _then) = _$BreedsNoticeCopyWithImpl;
@useResult
$Res call({
 int id, BreedsNoticeKind kind, Failure? failure
});


$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$BreedsNoticeCopyWithImpl<$Res>
    implements $BreedsNoticeCopyWith<$Res> {
  _$BreedsNoticeCopyWithImpl(this._self, this._then);

  final BreedsNotice _self;
  final $Res Function(BreedsNotice) _then;

/// Create a copy of BreedsNotice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BreedsNoticeKind,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of BreedsNotice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [BreedsNotice].
extension BreedsNoticePatterns on BreedsNotice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedsNotice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedsNotice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedsNotice value)  $default,){
final _that = this;
switch (_that) {
case _BreedsNotice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedsNotice value)?  $default,){
final _that = this;
switch (_that) {
case _BreedsNotice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  BreedsNoticeKind kind,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedsNotice() when $default != null:
return $default(_that.id,_that.kind,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  BreedsNoticeKind kind,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _BreedsNotice():
return $default(_that.id,_that.kind,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  BreedsNoticeKind kind,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _BreedsNotice() when $default != null:
return $default(_that.id,_that.kind,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _BreedsNotice implements BreedsNotice {
  const _BreedsNotice({required this.id, required this.kind, this.failure});
  

@override final  int id;
@override final  BreedsNoticeKind kind;
@override final  Failure? failure;

/// Create a copy of BreedsNotice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedsNoticeCopyWith<_BreedsNotice> get copyWith => __$BreedsNoticeCopyWithImpl<_BreedsNotice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedsNotice&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,failure);

@override
String toString() {
  return 'BreedsNotice(id: $id, kind: $kind, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$BreedsNoticeCopyWith<$Res> implements $BreedsNoticeCopyWith<$Res> {
  factory _$BreedsNoticeCopyWith(_BreedsNotice value, $Res Function(_BreedsNotice) _then) = __$BreedsNoticeCopyWithImpl;
@override @useResult
$Res call({
 int id, BreedsNoticeKind kind, Failure? failure
});


@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$BreedsNoticeCopyWithImpl<$Res>
    implements _$BreedsNoticeCopyWith<$Res> {
  __$BreedsNoticeCopyWithImpl(this._self, this._then);

  final _BreedsNotice _self;
  final $Res Function(_BreedsNotice) _then;

/// Create a copy of BreedsNotice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? failure = freezed,}) {
  return _then(_BreedsNotice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BreedsNoticeKind,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of BreedsNotice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

/// @nodoc
mixin _$BreedsState {

 BreedsStatus get status;/// Paginas cargadas por numero. Es la fuente de verdad: permite
/// reemplazar solo la pagina 1 al revalidar sin perder el resto.
 Map<int, List<Breed>> get pages;/// Todas las razas cargadas, en orden y sin duplicados.
 List<Breed> get breeds;/// Las que pasan el filtro de busqueda (o todas si no hay busqueda).
 List<Breed> get visible; String get query; int get lastPage; int get total; bool get isLoadingMore; bool get isRefreshing;/// Fallo que deja la pantalla sin datos.
 Failure? get failure;/// Fallo de la ultima pagina pedida: la lista ya cargada se conserva.
 Failure? get paginationFailure; DataOrigin? get origin; bool get isStale; DateTime? get updatedAt; BreedsNotice? get notice;
/// Create a copy of BreedsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedsStateCopyWith<BreedsState> get copyWith => _$BreedsStateCopyWithImpl<BreedsState>(this as BreedsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.pages, pages)&&const DeepCollectionEquality().equals(other.breeds, breeds)&&const DeepCollectionEquality().equals(other.visible, visible)&&(identical(other.query, query) || other.query == query)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.paginationFailure, paginationFailure) || other.paginationFailure == paginationFailure)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.isStale, isStale) || other.isStale == isStale)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.notice, notice) || other.notice == notice));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(pages),const DeepCollectionEquality().hash(breeds),const DeepCollectionEquality().hash(visible),query,lastPage,total,isLoadingMore,isRefreshing,failure,paginationFailure,origin,isStale,updatedAt,notice);

@override
String toString() {
  return 'BreedsState(status: $status, pages: $pages, breeds: $breeds, visible: $visible, query: $query, lastPage: $lastPage, total: $total, isLoadingMore: $isLoadingMore, isRefreshing: $isRefreshing, failure: $failure, paginationFailure: $paginationFailure, origin: $origin, isStale: $isStale, updatedAt: $updatedAt, notice: $notice)';
}


}

/// @nodoc
abstract mixin class $BreedsStateCopyWith<$Res>  {
  factory $BreedsStateCopyWith(BreedsState value, $Res Function(BreedsState) _then) = _$BreedsStateCopyWithImpl;
@useResult
$Res call({
 BreedsStatus status, Map<int, List<Breed>> pages, List<Breed> breeds, List<Breed> visible, String query, int lastPage, int total, bool isLoadingMore, bool isRefreshing, Failure? failure, Failure? paginationFailure, DataOrigin? origin, bool isStale, DateTime? updatedAt, BreedsNotice? notice
});


$FailureCopyWith<$Res>? get failure;$FailureCopyWith<$Res>? get paginationFailure;$BreedsNoticeCopyWith<$Res>? get notice;

}
/// @nodoc
class _$BreedsStateCopyWithImpl<$Res>
    implements $BreedsStateCopyWith<$Res> {
  _$BreedsStateCopyWithImpl(this._self, this._then);

  final BreedsState _self;
  final $Res Function(BreedsState) _then;

/// Create a copy of BreedsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? pages = null,Object? breeds = null,Object? visible = null,Object? query = null,Object? lastPage = null,Object? total = null,Object? isLoadingMore = null,Object? isRefreshing = null,Object? failure = freezed,Object? paginationFailure = freezed,Object? origin = freezed,Object? isStale = null,Object? updatedAt = freezed,Object? notice = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BreedsStatus,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as Map<int, List<Breed>>,breeds: null == breeds ? _self.breeds : breeds // ignore: cast_nullable_to_non_nullable
as List<Breed>,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as List<Breed>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,paginationFailure: freezed == paginationFailure ? _self.paginationFailure : paginationFailure // ignore: cast_nullable_to_non_nullable
as Failure?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as DataOrigin?,isStale: null == isStale ? _self.isStale : isStale // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as BreedsNotice?,
  ));
}
/// Create a copy of BreedsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of BreedsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get paginationFailure {
    if (_self.paginationFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.paginationFailure!, (value) {
    return _then(_self.copyWith(paginationFailure: value));
  });
}/// Create a copy of BreedsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedsNoticeCopyWith<$Res>? get notice {
    if (_self.notice == null) {
    return null;
  }

  return $BreedsNoticeCopyWith<$Res>(_self.notice!, (value) {
    return _then(_self.copyWith(notice: value));
  });
}
}


/// Adds pattern-matching-related methods to [BreedsState].
extension BreedsStatePatterns on BreedsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedsState value)  $default,){
final _that = this;
switch (_that) {
case _BreedsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedsState value)?  $default,){
final _that = this;
switch (_that) {
case _BreedsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BreedsStatus status,  Map<int, List<Breed>> pages,  List<Breed> breeds,  List<Breed> visible,  String query,  int lastPage,  int total,  bool isLoadingMore,  bool isRefreshing,  Failure? failure,  Failure? paginationFailure,  DataOrigin? origin,  bool isStale,  DateTime? updatedAt,  BreedsNotice? notice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedsState() when $default != null:
return $default(_that.status,_that.pages,_that.breeds,_that.visible,_that.query,_that.lastPage,_that.total,_that.isLoadingMore,_that.isRefreshing,_that.failure,_that.paginationFailure,_that.origin,_that.isStale,_that.updatedAt,_that.notice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BreedsStatus status,  Map<int, List<Breed>> pages,  List<Breed> breeds,  List<Breed> visible,  String query,  int lastPage,  int total,  bool isLoadingMore,  bool isRefreshing,  Failure? failure,  Failure? paginationFailure,  DataOrigin? origin,  bool isStale,  DateTime? updatedAt,  BreedsNotice? notice)  $default,) {final _that = this;
switch (_that) {
case _BreedsState():
return $default(_that.status,_that.pages,_that.breeds,_that.visible,_that.query,_that.lastPage,_that.total,_that.isLoadingMore,_that.isRefreshing,_that.failure,_that.paginationFailure,_that.origin,_that.isStale,_that.updatedAt,_that.notice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BreedsStatus status,  Map<int, List<Breed>> pages,  List<Breed> breeds,  List<Breed> visible,  String query,  int lastPage,  int total,  bool isLoadingMore,  bool isRefreshing,  Failure? failure,  Failure? paginationFailure,  DataOrigin? origin,  bool isStale,  DateTime? updatedAt,  BreedsNotice? notice)?  $default,) {final _that = this;
switch (_that) {
case _BreedsState() when $default != null:
return $default(_that.status,_that.pages,_that.breeds,_that.visible,_that.query,_that.lastPage,_that.total,_that.isLoadingMore,_that.isRefreshing,_that.failure,_that.paginationFailure,_that.origin,_that.isStale,_that.updatedAt,_that.notice);case _:
  return null;

}
}

}

/// @nodoc


class _BreedsState extends BreedsState {
  const _BreedsState({this.status = BreedsStatus.initial, final  Map<int, List<Breed>> pages = const <int, List<Breed>>{}, final  List<Breed> breeds = const <Breed>[], final  List<Breed> visible = const <Breed>[], this.query = '', this.lastPage = 0, this.total = 0, this.isLoadingMore = false, this.isRefreshing = false, this.failure, this.paginationFailure, this.origin, this.isStale = false, this.updatedAt, this.notice}): _pages = pages,_breeds = breeds,_visible = visible,super._();
  

@override@JsonKey() final  BreedsStatus status;
/// Paginas cargadas por numero. Es la fuente de verdad: permite
/// reemplazar solo la pagina 1 al revalidar sin perder el resto.
 final  Map<int, List<Breed>> _pages;
/// Paginas cargadas por numero. Es la fuente de verdad: permite
/// reemplazar solo la pagina 1 al revalidar sin perder el resto.
@override@JsonKey() Map<int, List<Breed>> get pages {
  if (_pages is EqualUnmodifiableMapView) return _pages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pages);
}

/// Todas las razas cargadas, en orden y sin duplicados.
 final  List<Breed> _breeds;
/// Todas las razas cargadas, en orden y sin duplicados.
@override@JsonKey() List<Breed> get breeds {
  if (_breeds is EqualUnmodifiableListView) return _breeds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_breeds);
}

/// Las que pasan el filtro de busqueda (o todas si no hay busqueda).
 final  List<Breed> _visible;
/// Las que pasan el filtro de busqueda (o todas si no hay busqueda).
@override@JsonKey() List<Breed> get visible {
  if (_visible is EqualUnmodifiableListView) return _visible;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_visible);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  int lastPage;
@override@JsonKey() final  int total;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool isRefreshing;
/// Fallo que deja la pantalla sin datos.
@override final  Failure? failure;
/// Fallo de la ultima pagina pedida: la lista ya cargada se conserva.
@override final  Failure? paginationFailure;
@override final  DataOrigin? origin;
@override@JsonKey() final  bool isStale;
@override final  DateTime? updatedAt;
@override final  BreedsNotice? notice;

/// Create a copy of BreedsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedsStateCopyWith<_BreedsState> get copyWith => __$BreedsStateCopyWithImpl<_BreedsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._pages, _pages)&&const DeepCollectionEquality().equals(other._breeds, _breeds)&&const DeepCollectionEquality().equals(other._visible, _visible)&&(identical(other.query, query) || other.query == query)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.paginationFailure, paginationFailure) || other.paginationFailure == paginationFailure)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.isStale, isStale) || other.isStale == isStale)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.notice, notice) || other.notice == notice));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_pages),const DeepCollectionEquality().hash(_breeds),const DeepCollectionEquality().hash(_visible),query,lastPage,total,isLoadingMore,isRefreshing,failure,paginationFailure,origin,isStale,updatedAt,notice);

@override
String toString() {
  return 'BreedsState(status: $status, pages: $pages, breeds: $breeds, visible: $visible, query: $query, lastPage: $lastPage, total: $total, isLoadingMore: $isLoadingMore, isRefreshing: $isRefreshing, failure: $failure, paginationFailure: $paginationFailure, origin: $origin, isStale: $isStale, updatedAt: $updatedAt, notice: $notice)';
}


}

/// @nodoc
abstract mixin class _$BreedsStateCopyWith<$Res> implements $BreedsStateCopyWith<$Res> {
  factory _$BreedsStateCopyWith(_BreedsState value, $Res Function(_BreedsState) _then) = __$BreedsStateCopyWithImpl;
@override @useResult
$Res call({
 BreedsStatus status, Map<int, List<Breed>> pages, List<Breed> breeds, List<Breed> visible, String query, int lastPage, int total, bool isLoadingMore, bool isRefreshing, Failure? failure, Failure? paginationFailure, DataOrigin? origin, bool isStale, DateTime? updatedAt, BreedsNotice? notice
});


@override $FailureCopyWith<$Res>? get failure;@override $FailureCopyWith<$Res>? get paginationFailure;@override $BreedsNoticeCopyWith<$Res>? get notice;

}
/// @nodoc
class __$BreedsStateCopyWithImpl<$Res>
    implements _$BreedsStateCopyWith<$Res> {
  __$BreedsStateCopyWithImpl(this._self, this._then);

  final _BreedsState _self;
  final $Res Function(_BreedsState) _then;

/// Create a copy of BreedsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? pages = null,Object? breeds = null,Object? visible = null,Object? query = null,Object? lastPage = null,Object? total = null,Object? isLoadingMore = null,Object? isRefreshing = null,Object? failure = freezed,Object? paginationFailure = freezed,Object? origin = freezed,Object? isStale = null,Object? updatedAt = freezed,Object? notice = freezed,}) {
  return _then(_BreedsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BreedsStatus,pages: null == pages ? _self._pages : pages // ignore: cast_nullable_to_non_nullable
as Map<int, List<Breed>>,breeds: null == breeds ? _self._breeds : breeds // ignore: cast_nullable_to_non_nullable
as List<Breed>,visible: null == visible ? _self._visible : visible // ignore: cast_nullable_to_non_nullable
as List<Breed>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,paginationFailure: freezed == paginationFailure ? _self.paginationFailure : paginationFailure // ignore: cast_nullable_to_non_nullable
as Failure?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as DataOrigin?,isStale: null == isStale ? _self.isStale : isStale // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as BreedsNotice?,
  ));
}

/// Create a copy of BreedsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of BreedsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get paginationFailure {
    if (_self.paginationFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.paginationFailure!, (value) {
    return _then(_self.copyWith(paginationFailure: value));
  });
}/// Create a copy of BreedsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedsNoticeCopyWith<$Res>? get notice {
    if (_self.notice == null) {
    return null;
  }

  return $BreedsNoticeCopyWith<$Res>(_self.notice!, (value) {
    return _then(_self.copyWith(notice: value));
  });
}
}

// dart format on
