// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breed_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BreedDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BreedDetailState()';
}


}

/// @nodoc
class $BreedDetailStateCopyWith<$Res>  {
$BreedDetailStateCopyWith(BreedDetailState _, $Res Function(BreedDetailState) __);
}


/// Adds pattern-matching-related methods to [BreedDetailState].
extension BreedDetailStatePatterns on BreedDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BreedDetailLoading value)?  loading,TResult Function( BreedDetailLoaded value)?  loaded,TResult Function( BreedDetailFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BreedDetailLoading() when loading != null:
return loading(_that);case BreedDetailLoaded() when loaded != null:
return loaded(_that);case BreedDetailFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BreedDetailLoading value)  loading,required TResult Function( BreedDetailLoaded value)  loaded,required TResult Function( BreedDetailFailure value)  failure,}){
final _that = this;
switch (_that) {
case BreedDetailLoading():
return loading(_that);case BreedDetailLoaded():
return loaded(_that);case BreedDetailFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BreedDetailLoading value)?  loading,TResult? Function( BreedDetailLoaded value)?  loaded,TResult? Function( BreedDetailFailure value)?  failure,}){
final _that = this;
switch (_that) {
case BreedDetailLoading() when loading != null:
return loading(_that);case BreedDetailLoaded() when loaded != null:
return loaded(_that);case BreedDetailFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Breed breed)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BreedDetailLoading() when loading != null:
return loading();case BreedDetailLoaded() when loaded != null:
return loaded(_that.breed);case BreedDetailFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Breed breed)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case BreedDetailLoading():
return loading();case BreedDetailLoaded():
return loaded(_that.breed);case BreedDetailFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Breed breed)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case BreedDetailLoading() when loading != null:
return loading();case BreedDetailLoaded() when loaded != null:
return loaded(_that.breed);case BreedDetailFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class BreedDetailLoading implements BreedDetailState {
  const BreedDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BreedDetailState.loading()';
}


}




/// @nodoc


class BreedDetailLoaded implements BreedDetailState {
  const BreedDetailLoaded(this.breed);
  

 final  Breed breed;

/// Create a copy of BreedDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedDetailLoadedCopyWith<BreedDetailLoaded> get copyWith => _$BreedDetailLoadedCopyWithImpl<BreedDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedDetailLoaded&&(identical(other.breed, breed) || other.breed == breed));
}


@override
int get hashCode => Object.hash(runtimeType,breed);

@override
String toString() {
  return 'BreedDetailState.loaded(breed: $breed)';
}


}

/// @nodoc
abstract mixin class $BreedDetailLoadedCopyWith<$Res> implements $BreedDetailStateCopyWith<$Res> {
  factory $BreedDetailLoadedCopyWith(BreedDetailLoaded value, $Res Function(BreedDetailLoaded) _then) = _$BreedDetailLoadedCopyWithImpl;
@useResult
$Res call({
 Breed breed
});


$BreedCopyWith<$Res> get breed;

}
/// @nodoc
class _$BreedDetailLoadedCopyWithImpl<$Res>
    implements $BreedDetailLoadedCopyWith<$Res> {
  _$BreedDetailLoadedCopyWithImpl(this._self, this._then);

  final BreedDetailLoaded _self;
  final $Res Function(BreedDetailLoaded) _then;

/// Create a copy of BreedDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? breed = null,}) {
  return _then(BreedDetailLoaded(
null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as Breed,
  ));
}

/// Create a copy of BreedDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedCopyWith<$Res> get breed {
  
  return $BreedCopyWith<$Res>(_self.breed, (value) {
    return _then(_self.copyWith(breed: value));
  });
}
}

/// @nodoc


class BreedDetailFailure implements BreedDetailState {
  const BreedDetailFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of BreedDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedDetailFailureCopyWith<BreedDetailFailure> get copyWith => _$BreedDetailFailureCopyWithImpl<BreedDetailFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedDetailFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'BreedDetailState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $BreedDetailFailureCopyWith<$Res> implements $BreedDetailStateCopyWith<$Res> {
  factory $BreedDetailFailureCopyWith(BreedDetailFailure value, $Res Function(BreedDetailFailure) _then) = _$BreedDetailFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$BreedDetailFailureCopyWithImpl<$Res>
    implements $BreedDetailFailureCopyWith<$Res> {
  _$BreedDetailFailureCopyWithImpl(this._self, this._then);

  final BreedDetailFailure _self;
  final $Res Function(BreedDetailFailure) _then;

/// Create a copy of BreedDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(BreedDetailFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of BreedDetailState
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
