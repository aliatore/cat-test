import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cat_directory_app/core/network/network_info.dart';
import 'package:cat_directory_app/core/network/retry_interceptor.dart';
import 'package:meta/meta.dart';

@immutable
class ConnectivityState {
  const ConnectivityState({this.online = true, this.retry});

  final bool online;

  /// Reintento en curso, si lo hay. Se limpia solo unos segundos despues.
  final RetryAttempt? retry;

  ConnectivityState copyWith({bool? online, RetryAttempt? Function()? retry}) =>
      ConnectivityState(
        online: online ?? this.online,
        retry: retry == null ? this.retry : retry(),
      );

  @override
  bool operator ==(Object other) =>
      other is ConnectivityState &&
      other.online == online &&
      identical(other.retry, retry);

  @override
  int get hashCode => Object.hash(online, retry);
}

/// Estado de la senal para la cabecera y el banner: sin red, reconectando...
class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit({
    required NetworkInfo networkInfo,
    required Stream<RetryAttempt> retries,
  }) : super(const ConnectivityState()) {
    _status = networkInfo.onStatusChange.listen(
      (online) => emit(state.copyWith(online: online)),
    );
    _retries = retries.listen(_onRetry);
    unawaited(
      networkInfo.isConnected.then((online) {
        if (!isClosed) emit(state.copyWith(online: online));
      }),
    );
  }

  late final StreamSubscription<bool> _status;
  late final StreamSubscription<RetryAttempt> _retries;
  Timer? _clearRetry;

  void _onRetry(RetryAttempt attempt) {
    emit(state.copyWith(retry: () => attempt));
    _clearRetry?.cancel();
    _clearRetry = Timer(attempt.delay + const Duration(seconds: 2), () {
      if (!isClosed) emit(state.copyWith(retry: () => null));
    });
  }

  @override
  Future<void> close() async {
    _clearRetry?.cancel();
    await _status.cancel();
    await _retries.cancel();
    return super.close();
  }
}
