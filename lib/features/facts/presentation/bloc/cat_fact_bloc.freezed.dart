// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cat_fact_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatFactState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatFactState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CatFactState()';
}


}

/// @nodoc
class $CatFactStateCopyWith<$Res>  {
$CatFactStateCopyWith(CatFactState _, $Res Function(CatFactState) __);
}


/// Adds pattern-matching-related methods to [CatFactState].
extension CatFactStatePatterns on CatFactState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CatFactLoading value)?  loading,TResult Function( CatFactLoaded value)?  loaded,TResult Function( CatFactFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CatFactLoading() when loading != null:
return loading(_that);case CatFactLoaded() when loaded != null:
return loaded(_that);case CatFactFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CatFactLoading value)  loading,required TResult Function( CatFactLoaded value)  loaded,required TResult Function( CatFactFailure value)  failure,}){
final _that = this;
switch (_that) {
case CatFactLoading():
return loading(_that);case CatFactLoaded():
return loaded(_that);case CatFactFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CatFactLoading value)?  loading,TResult? Function( CatFactLoaded value)?  loaded,TResult? Function( CatFactFailure value)?  failure,}){
final _that = this;
switch (_that) {
case CatFactLoading() when loading != null:
return loading(_that);case CatFactLoaded() when loaded != null:
return loaded(_that);case CatFactFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( CatFact fact)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CatFactLoading() when loading != null:
return loading();case CatFactLoaded() when loaded != null:
return loaded(_that.fact);case CatFactFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( CatFact fact)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case CatFactLoading():
return loading();case CatFactLoaded():
return loaded(_that.fact);case CatFactFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( CatFact fact)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case CatFactLoading() when loading != null:
return loading();case CatFactLoaded() when loaded != null:
return loaded(_that.fact);case CatFactFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class CatFactLoading implements CatFactState {
  const CatFactLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatFactLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CatFactState.loading()';
}


}




/// @nodoc


class CatFactLoaded implements CatFactState {
  const CatFactLoaded(this.fact);
  

 final  CatFact fact;

/// Create a copy of CatFactState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatFactLoadedCopyWith<CatFactLoaded> get copyWith => _$CatFactLoadedCopyWithImpl<CatFactLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatFactLoaded&&(identical(other.fact, fact) || other.fact == fact));
}


@override
int get hashCode => Object.hash(runtimeType,fact);

@override
String toString() {
  return 'CatFactState.loaded(fact: $fact)';
}


}

/// @nodoc
abstract mixin class $CatFactLoadedCopyWith<$Res> implements $CatFactStateCopyWith<$Res> {
  factory $CatFactLoadedCopyWith(CatFactLoaded value, $Res Function(CatFactLoaded) _then) = _$CatFactLoadedCopyWithImpl;
@useResult
$Res call({
 CatFact fact
});


$CatFactCopyWith<$Res> get fact;

}
/// @nodoc
class _$CatFactLoadedCopyWithImpl<$Res>
    implements $CatFactLoadedCopyWith<$Res> {
  _$CatFactLoadedCopyWithImpl(this._self, this._then);

  final CatFactLoaded _self;
  final $Res Function(CatFactLoaded) _then;

/// Create a copy of CatFactState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fact = null,}) {
  return _then(CatFactLoaded(
null == fact ? _self.fact : fact // ignore: cast_nullable_to_non_nullable
as CatFact,
  ));
}

/// Create a copy of CatFactState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CatFactCopyWith<$Res> get fact {
  
  return $CatFactCopyWith<$Res>(_self.fact, (value) {
    return _then(_self.copyWith(fact: value));
  });
}
}

/// @nodoc


class CatFactFailure implements CatFactState {
  const CatFactFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of CatFactState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatFactFailureCopyWith<CatFactFailure> get copyWith => _$CatFactFailureCopyWithImpl<CatFactFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatFactFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'CatFactState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CatFactFailureCopyWith<$Res> implements $CatFactStateCopyWith<$Res> {
  factory $CatFactFailureCopyWith(CatFactFailure value, $Res Function(CatFactFailure) _then) = _$CatFactFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$CatFactFailureCopyWithImpl<$Res>
    implements $CatFactFailureCopyWith<$Res> {
  _$CatFactFailureCopyWithImpl(this._self, this._then);

  final CatFactFailure _self;
  final $Res Function(CatFactFailure) _then;

/// Create a copy of CatFactState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(CatFactFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of CatFactState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
