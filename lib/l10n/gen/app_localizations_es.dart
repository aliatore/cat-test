// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'NekoDex';

  @override
  String get directoryTagline => 'Directorio felino';

  @override
  String directoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count razas en la red',
      one: '1 raza en la red',
      zero: 'Sin razas',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'buscar_raza…';

  @override
  String get searchLabel => 'Buscar raza por nombre';

  @override
  String get searchClear => 'Borrar búsqueda';

  @override
  String searchResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count coincidencias',
      one: '1 coincidencia',
      zero: 'Sin coincidencias',
    );
    return '$_temp0';
  }

  @override
  String searchScope(int count) {
    return 'Buscando entre $count razas cargadas';
  }

  @override
  String get searchLoadMore => 'Cargar más razas';

  @override
  String get statusLive => 'En vivo';

  @override
  String get statusCache => 'Caché';

  @override
  String get statusOffline => 'Sin señal';

  @override
  String get statusSyncing => 'Sincronizando';

  @override
  String statusSemantics(String status) {
    return 'Estado de los datos: $status';
  }

  @override
  String bannerOffline(String age) {
    return 'Sin conexión. Mostrando datos guardados $age.';
  }

  @override
  String get bannerOfflineEmpty => 'Sin conexión a internet.';

  @override
  String bannerRetrying(int attempt, int max) {
    return 'Reconectando… intento $attempt de $max';
  }

  @override
  String bannerStale(String age) {
    return 'Datos guardados $age. Actualizando en segundo plano…';
  }

  @override
  String get ageJustNow => 'hace un momento';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count minutos',
      one: 'hace 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count horas',
      one: 'hace 1 hora',
    );
    return '$_temp0';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String breedTileSemantics(String name, String country) {
    return '$name. País: $country.';
  }

  @override
  String get breedTileHint => 'ver ficha';

  @override
  String get unknownCountry => 'País desconocido';

  @override
  String get unknownValue => 'Sin datos';

  @override
  String get loadingBreeds => 'Cargando razas';

  @override
  String get paginationLoading => 'Cargando más razas…';

  @override
  String get paginationError =>
      'No se pudo cargar la página siguiente. La lista sigue aquí.';

  @override
  String get retry => 'Reintentar';

  @override
  String endOfList(int count) {
    return 'Fin del directorio · $count razas';
  }

  @override
  String get errorOfflineTitle => 'Sin conexión a la red felina';

  @override
  String get errorOfflineMessage =>
      'Todavía no hay datos guardados en este teléfono. Reintentamos solos cuando vuelva la conexión.';

  @override
  String get errorServerTitle => 'La API no responde';

  @override
  String get errorServerMessage =>
      'El servidor de gatos está teniendo un mal día. Ya lo intentamos varias veces; prueba en un momento.';

  @override
  String get errorRateLimitedTitle => 'Demasiadas peticiones';

  @override
  String get errorRateLimitedMessage =>
      'La API pide un respiro. Espera unos segundos y reintenta.';

  @override
  String get errorGenericTitle => 'Algo salió mal';

  @override
  String get errorGenericMessage =>
      'No pudimos cargar el directorio. Reintenta en un momento.';

  @override
  String emptySearchTitle(String query) {
    return 'Ningún gato responde a «$query»';
  }

  @override
  String get emptySearchMessage =>
      'La búsqueda es sobre las razas ya cargadas. Carga más o prueba otro nombre.';

  @override
  String get noticeShowingCache => 'Sin conexión: mostrando datos guardados.';

  @override
  String get noticeRefreshFailed =>
      'No se pudo actualizar. La lista sigue disponible.';

  @override
  String get noticeBackOnline => 'Conexión restablecida';

  @override
  String get noticeRefreshed => 'Directorio actualizado';

  @override
  String get noticeRateLimited =>
      'La API pide un respiro. Reintenta en unos segundos.';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get backTooltip => 'Volver';

  @override
  String get detailCountry => 'País';

  @override
  String get detailOrigin => 'Origen';

  @override
  String get detailCoat => 'Pelaje';

  @override
  String get detailPattern => 'Patrón';

  @override
  String detailSerial(String serial) {
    return 'ID $serial';
  }

  @override
  String get detailLoading => 'Buscando la raza…';

  @override
  String get detailNotFoundTitle => 'Esa raza no está en el directorio';

  @override
  String get detailNotFoundMessage =>
      'Puede que el enlace esté mal escrito. Vuelve al listado y búscala allí.';

  @override
  String get detailGoToDirectory => 'Ir al directorio';

  @override
  String get detailCopyLink => 'Copiar enlace';

  @override
  String get detailLinkCopied => 'Enlace copiado';

  @override
  String detailAvatarSemantics(String name) {
    return 'Avatar de $name';
  }

  @override
  String get detailPetHint => 'Tócalo para acariciarlo';

  @override
  String get factTitle => 'Dato curioso';

  @override
  String get factLoading => 'Consultando la red felina…';

  @override
  String get factAnother => 'Otro dato';

  @override
  String get factLive => 'En vivo';

  @override
  String get factSaved => 'Guardado';

  @override
  String get factSavedHint => 'Sin conexión: es un dato que ya habías visto.';

  @override
  String get factError => 'No pudimos traer un dato curioso.';

  @override
  String get factLanguage => 'Los datos llegan en inglés desde la API.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get settingsSound => 'Efectos de sonido';

  @override
  String get settingsSoundDescription =>
      'Respetan el modo silencio y no pausan tu música.';

  @override
  String get settingsDailyBreed => 'Raza del día';

  @override
  String settingsDailyBreedDescription(String time) {
    return 'Una notificación local cada día a las $time con una raza del directorio.';
  }

  @override
  String get settingsTestNotification => 'Enviar notificación de prueba';

  @override
  String get settingsTestNotificationSent =>
      'Llega en unos segundos. Puedes salir de la app para verla.';

  @override
  String get settingsNotificationsDenied =>
      'Las notificaciones de NekoDex están desactivadas en el sistema.';

  @override
  String get settingsOpenSystemSettings => 'Abrir ajustes';

  @override
  String get settingsCache => 'Caché del directorio';

  @override
  String settingsCacheSummary(int breeds, int pages, String age) {
    return '$breeds razas · $pages páginas · $age';
  }

  @override
  String get settingsCacheEmpty => 'Vacía';

  @override
  String get settingsCachePolicy =>
      'Fresca 5 min · se revalida hasta 7 días · luego se descarta';

  @override
  String get settingsClearCache => 'Borrar caché';

  @override
  String get settingsCacheCleared =>
      'Caché borrada. El directorio se recargará desde la API.';

  @override
  String get settingsPerformanceOverlay => 'Overlay de rendimiento';

  @override
  String get settingsPerformanceOverlayDescription =>
      'Muestra las gráficas de frames de la GPU y la UI.';

  @override
  String settingsAbout(String version) {
    return 'Datos de catfact.ninja · v$version';
  }

  @override
  String get notificationChannelName => 'Raza del día';

  @override
  String get notificationChannelDescription =>
      'Una raza del directorio cada día.';

  @override
  String notificationBreedTitle(String name) {
    return 'Raza del día: $name';
  }

  @override
  String notificationBreedBody(String country, String coat) {
    return '$country · pelaje $coat. Toca para ver su ficha.';
  }

  @override
  String get splashSkip => 'Toca para saltar';

  @override
  String get routeNotFoundTitle => 'Ruta desconocida';

  @override
  String routeNotFoundMessage(String path) {
    return 'No hay nada en $path.';
  }
}
