part of 'breeds_bloc.dart';

sealed class BreedsEvent {
  const BreedsEvent();
}

/// Arranque: muestra la cache al instante y revalida (stale-while-revalidate).
final class BreedsStarted extends BreedsEvent {
  const BreedsStarted();
}

/// El scroll llego cerca del final. Se procesa con `droppable`: si ya hay
/// una pagina en camino, los eventos que lleguen mientras tanto se descartan.
final class BreedsNextPageRequested extends BreedsEvent {
  const BreedsNextPageRequested();
}

/// Pull to refresh: vuelve a la pagina 1 ignorando la cache.
final class BreedsRefreshRequested extends BreedsEvent {
  const BreedsRefreshRequested();
}

final class BreedsRetryRequested extends BreedsEvent {
  const BreedsRetryRequested();
}

/// Texto del buscador. Llega con debounce y `restartable`: solo cuenta el
/// ultimo valor que el usuario dejo quieto 300 ms.
final class BreedsQueryChanged extends BreedsEvent {
  const BreedsQueryChanged(this.query);

  final String query;
}

/// Revalidacion silenciosa (la app volvio a primer plano, o volvio la red).
final class BreedsRevalidateRequested extends BreedsEvent {
  const BreedsRevalidateRequested();
}

final class _ConnectivityChanged extends BreedsEvent {
  const _ConnectivityChanged({required this.online});

  final bool online;
}
