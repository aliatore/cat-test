// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure()';
}


}

/// @nodoc
class $FailureCopyWith<$Res>  {
$FailureCopyWith(Failure _, $Res Function(Failure) __);
}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ConnectionFailure value)?  connection,TResult Function( TimeoutFailure value)?  timeout,TResult Function( ServerFailure value)?  server,TResult Function( RateLimitedFailure value)?  rateLimited,TResult Function( RequestFailure value)?  request,TResult Function( ParsingFailure value)?  parsing,TResult Function( CacheFailure value)?  cache,TResult Function( NotFoundFailure value)?  notFound,TResult Function( UnexpectedFailure value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ConnectionFailure() when connection != null:
return connection(_that);case TimeoutFailure() when timeout != null:
return timeout(_that);case ServerFailure() when server != null:
return server(_that);case RateLimitedFailure() when rateLimited != null:
return rateLimited(_that);case RequestFailure() when request != null:
return request(_that);case ParsingFailure() when parsing != null:
return parsing(_that);case CacheFailure() when cache != null:
return cache(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ConnectionFailure value)  connection,required TResult Function( TimeoutFailure value)  timeout,required TResult Function( ServerFailure value)  server,required TResult Function( RateLimitedFailure value)  rateLimited,required TResult Function( RequestFailure value)  request,required TResult Function( ParsingFailure value)  parsing,required TResult Function( CacheFailure value)  cache,required TResult Function( NotFoundFailure value)  notFound,required TResult Function( UnexpectedFailure value)  unexpected,}){
final _that = this;
switch (_that) {
case ConnectionFailure():
return connection(_that);case TimeoutFailure():
return timeout(_that);case ServerFailure():
return server(_that);case RateLimitedFailure():
return rateLimited(_that);case RequestFailure():
return request(_that);case ParsingFailure():
return parsing(_that);case CacheFailure():
return cache(_that);case NotFoundFailure():
return notFound(_that);case UnexpectedFailure():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ConnectionFailure value)?  connection,TResult? Function( TimeoutFailure value)?  timeout,TResult? Function( ServerFailure value)?  server,TResult? Function( RateLimitedFailure value)?  rateLimited,TResult? Function( RequestFailure value)?  request,TResult? Function( ParsingFailure value)?  parsing,TResult? Function( CacheFailure value)?  cache,TResult? Function( NotFoundFailure value)?  notFound,TResult? Function( UnexpectedFailure value)?  unexpected,}){
final _that = this;
switch (_that) {
case ConnectionFailure() when connection != null:
return connection(_that);case TimeoutFailure() when timeout != null:
return timeout(_that);case ServerFailure() when server != null:
return server(_that);case RateLimitedFailure() when rateLimited != null:
return rateLimited(_that);case RequestFailure() when request != null:
return request(_that);case ParsingFailure() when parsing != null:
return parsing(_that);case CacheFailure() when cache != null:
return cache(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  connection,TResult Function()?  timeout,TResult Function( int? statusCode)?  server,TResult Function( Duration? retryAfter)?  rateLimited,TResult Function( int statusCode)?  request,TResult Function()?  parsing,TResult Function()?  cache,TResult Function()?  notFound,TResult Function()?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ConnectionFailure() when connection != null:
return connection();case TimeoutFailure() when timeout != null:
return timeout();case ServerFailure() when server != null:
return server(_that.statusCode);case RateLimitedFailure() when rateLimited != null:
return rateLimited(_that.retryAfter);case RequestFailure() when request != null:
return request(_that.statusCode);case ParsingFailure() when parsing != null:
return parsing();case CacheFailure() when cache != null:
return cache();case NotFoundFailure() when notFound != null:
return notFound();case UnexpectedFailure() when unexpected != null:
return unexpected();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  connection,required TResult Function()  timeout,required TResult Function( int? statusCode)  server,required TResult Function( Duration? retryAfter)  rateLimited,required TResult Function( int statusCode)  request,required TResult Function()  parsing,required TResult Function()  cache,required TResult Function()  notFound,required TResult Function()  unexpected,}) {final _that = this;
switch (_that) {
case ConnectionFailure():
return connection();case TimeoutFailure():
return timeout();case ServerFailure():
return server(_that.statusCode);case RateLimitedFailure():
return rateLimited(_that.retryAfter);case RequestFailure():
return request(_that.statusCode);case ParsingFailure():
return parsing();case CacheFailure():
return cache();case NotFoundFailure():
return notFound();case UnexpectedFailure():
return unexpected();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  connection,TResult? Function()?  timeout,TResult? Function( int? statusCode)?  server,TResult? Function( Duration? retryAfter)?  rateLimited,TResult? Function( int statusCode)?  request,TResult? Function()?  parsing,TResult? Function()?  cache,TResult? Function()?  notFound,TResult? Function()?  unexpected,}) {final _that = this;
switch (_that) {
case ConnectionFailure() when connection != null:
return connection();case TimeoutFailure() when timeout != null:
return timeout();case ServerFailure() when server != null:
return server(_that.statusCode);case RateLimitedFailure() when rateLimited != null:
return rateLimited(_that.retryAfter);case RequestFailure() when request != null:
return request(_that.statusCode);case ParsingFailure() when parsing != null:
return parsing();case CacheFailure() when cache != null:
return cache();case NotFoundFailure() when notFound != null:
return notFound();case UnexpectedFailure() when unexpected != null:
return unexpected();case _:
  return null;

}
}

}

/// @nodoc


class ConnectionFailure extends Failure {
  const ConnectionFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.connection()';
}


}




/// @nodoc


class TimeoutFailure extends Failure {
  const TimeoutFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeoutFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.timeout()';
}


}




/// @nodoc


class ServerFailure extends Failure {
  const ServerFailure({this.statusCode}): super._();
  

 final  int? statusCode;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode);

@override
String toString() {
  return 'Failure.server(statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@useResult
$Res call({
 int? statusCode
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,}) {
  return _then(ServerFailure(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class RateLimitedFailure extends Failure {
  const RateLimitedFailure({this.retryAfter}): super._();
  

 final  Duration? retryAfter;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RateLimitedFailureCopyWith<RateLimitedFailure> get copyWith => _$RateLimitedFailureCopyWithImpl<RateLimitedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RateLimitedFailure&&(identical(other.retryAfter, retryAfter) || other.retryAfter == retryAfter));
}


@override
int get hashCode => Object.hash(runtimeType,retryAfter);

@override
String toString() {
  return 'Failure.rateLimited(retryAfter: $retryAfter)';
}


}

/// @nodoc
abstract mixin class $RateLimitedFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $RateLimitedFailureCopyWith(RateLimitedFailure value, $Res Function(RateLimitedFailure) _then) = _$RateLimitedFailureCopyWithImpl;
@useResult
$Res call({
 Duration? retryAfter
});




}
/// @nodoc
class _$RateLimitedFailureCopyWithImpl<$Res>
    implements $RateLimitedFailureCopyWith<$Res> {
  _$RateLimitedFailureCopyWithImpl(this._self, this._then);

  final RateLimitedFailure _self;
  final $Res Function(RateLimitedFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? retryAfter = freezed,}) {
  return _then(RateLimitedFailure(
retryAfter: freezed == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

/// @nodoc


class RequestFailure extends Failure {
  const RequestFailure({required this.statusCode}): super._();
  

 final  int statusCode;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestFailureCopyWith<RequestFailure> get copyWith => _$RequestFailureCopyWithImpl<RequestFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode);

@override
String toString() {
  return 'Failure.request(statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $RequestFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $RequestFailureCopyWith(RequestFailure value, $Res Function(RequestFailure) _then) = _$RequestFailureCopyWithImpl;
@useResult
$Res call({
 int statusCode
});




}
/// @nodoc
class _$RequestFailureCopyWithImpl<$Res>
    implements $RequestFailureCopyWith<$Res> {
  _$RequestFailureCopyWithImpl(this._self, this._then);

  final RequestFailure _self;
  final $Res Function(RequestFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = null,}) {
  return _then(RequestFailure(
statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ParsingFailure extends Failure {
  const ParsingFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsingFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.parsing()';
}


}




/// @nodoc


class CacheFailure extends Failure {
  const CacheFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.cache()';
}


}




/// @nodoc


class NotFoundFailure extends Failure {
  const NotFoundFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.notFound()';
}


}




/// @nodoc


class UnexpectedFailure extends Failure {
  const UnexpectedFailure(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.unexpected()';
}


}




// dart format on
