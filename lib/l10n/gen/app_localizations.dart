import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'NekoDex'**
  String get appName;

  /// No description provided for @directoryTagline.
  ///
  /// In es, this message translates to:
  /// **'Directorio felino'**
  String get directoryTagline;

  /// No description provided for @directoryCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Sin razas} =1{1 raza en la red} other{{count} razas en la red}}'**
  String directoryCount(int count);

  /// No description provided for @searchHint.
  ///
  /// In es, this message translates to:
  /// **'buscar_raza…'**
  String get searchHint;

  /// No description provided for @searchLabel.
  ///
  /// In es, this message translates to:
  /// **'Buscar raza por nombre'**
  String get searchLabel;

  /// No description provided for @searchClear.
  ///
  /// In es, this message translates to:
  /// **'Borrar búsqueda'**
  String get searchClear;

  /// No description provided for @searchResults.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Sin coincidencias} =1{1 coincidencia} other{{count} coincidencias}}'**
  String searchResults(int count);

  /// No description provided for @searchScope.
  ///
  /// In es, this message translates to:
  /// **'Buscando entre {count} razas cargadas'**
  String searchScope(int count);

  /// No description provided for @searchLoadMore.
  ///
  /// In es, this message translates to:
  /// **'Cargar más razas'**
  String get searchLoadMore;

  /// No description provided for @statusLive.
  ///
  /// In es, this message translates to:
  /// **'En vivo'**
  String get statusLive;

  /// No description provided for @statusCache.
  ///
  /// In es, this message translates to:
  /// **'Caché'**
  String get statusCache;

  /// No description provided for @statusOffline.
  ///
  /// In es, this message translates to:
  /// **'Sin señal'**
  String get statusOffline;

  /// No description provided for @statusSyncing.
  ///
  /// In es, this message translates to:
  /// **'Sincronizando'**
  String get statusSyncing;

  /// No description provided for @statusSemantics.
  ///
  /// In es, this message translates to:
  /// **'Estado de los datos: {status}'**
  String statusSemantics(String status);

  /// No description provided for @bannerOffline.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Mostrando datos guardados {age}.'**
  String bannerOffline(String age);

  /// No description provided for @bannerOfflineEmpty.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet.'**
  String get bannerOfflineEmpty;

  /// No description provided for @bannerRetrying.
  ///
  /// In es, this message translates to:
  /// **'Reconectando… intento {attempt} de {max}'**
  String bannerRetrying(int attempt, int max);

  /// No description provided for @bannerStale.
  ///
  /// In es, this message translates to:
  /// **'Datos guardados {age}. Actualizando en segundo plano…'**
  String bannerStale(String age);

  /// No description provided for @ageJustNow.
  ///
  /// In es, this message translates to:
  /// **'hace un momento'**
  String get ageJustNow;

  /// No description provided for @ageMinutes.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{hace 1 minuto} other{hace {count} minutos}}'**
  String ageMinutes(int count);

  /// No description provided for @ageHours.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{hace 1 hora} other{hace {count} horas}}'**
  String ageHours(int count);

  /// No description provided for @ageDays.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{hace 1 día} other{hace {count} días}}'**
  String ageDays(int count);

  /// No description provided for @breedTileSemantics.
  ///
  /// In es, this message translates to:
  /// **'{name}. País: {country}.'**
  String breedTileSemantics(String name, String country);

  /// No description provided for @breedTileHint.
  ///
  /// In es, this message translates to:
  /// **'ver ficha'**
  String get breedTileHint;

  /// No description provided for @unknownCountry.
  ///
  /// In es, this message translates to:
  /// **'País desconocido'**
  String get unknownCountry;

  /// No description provided for @unknownValue.
  ///
  /// In es, this message translates to:
  /// **'Sin datos'**
  String get unknownValue;

  /// No description provided for @loadingBreeds.
  ///
  /// In es, this message translates to:
  /// **'Cargando razas'**
  String get loadingBreeds;

  /// No description provided for @paginationLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando más razas…'**
  String get paginationLoading;

  /// No description provided for @paginationError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la página siguiente. La lista sigue aquí.'**
  String get paginationError;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @endOfList.
  ///
  /// In es, this message translates to:
  /// **'Fin del directorio · {count} razas'**
  String endOfList(int count);

  /// No description provided for @errorOfflineTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a la red felina'**
  String get errorOfflineTitle;

  /// No description provided for @errorOfflineMessage.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay datos guardados en este teléfono. Reintentamos solos cuando vuelva la conexión.'**
  String get errorOfflineMessage;

  /// No description provided for @errorServerTitle.
  ///
  /// In es, this message translates to:
  /// **'La API no responde'**
  String get errorServerTitle;

  /// No description provided for @errorServerMessage.
  ///
  /// In es, this message translates to:
  /// **'El servidor de gatos está teniendo un mal día. Ya lo intentamos varias veces; prueba en un momento.'**
  String get errorServerMessage;

  /// No description provided for @errorRateLimitedTitle.
  ///
  /// In es, this message translates to:
  /// **'Demasiadas peticiones'**
  String get errorRateLimitedTitle;

  /// No description provided for @errorRateLimitedMessage.
  ///
  /// In es, this message translates to:
  /// **'La API pide un respiro. Espera unos segundos y reintenta.'**
  String get errorRateLimitedMessage;

  /// No description provided for @errorGenericTitle.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericMessage.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar el directorio. Reintenta en un momento.'**
  String get errorGenericMessage;

  /// No description provided for @emptySearchTitle.
  ///
  /// In es, this message translates to:
  /// **'Ningún gato responde a «{query}»'**
  String emptySearchTitle(String query);

  /// No description provided for @emptySearchMessage.
  ///
  /// In es, this message translates to:
  /// **'La búsqueda es sobre las razas ya cargadas. Carga más o prueba otro nombre.'**
  String get emptySearchMessage;

  /// No description provided for @noticeShowingCache.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión: mostrando datos guardados.'**
  String get noticeShowingCache;

  /// No description provided for @noticeRefreshFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo actualizar. La lista sigue disponible.'**
  String get noticeRefreshFailed;

  /// No description provided for @noticeBackOnline.
  ///
  /// In es, this message translates to:
  /// **'Conexión restablecida'**
  String get noticeBackOnline;

  /// No description provided for @noticeRefreshed.
  ///
  /// In es, this message translates to:
  /// **'Directorio actualizado'**
  String get noticeRefreshed;

  /// No description provided for @noticeRateLimited.
  ///
  /// In es, this message translates to:
  /// **'La API pide un respiro. Reintenta en unos segundos.'**
  String get noticeRateLimited;

  /// No description provided for @settingsTooltip.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTooltip;

  /// No description provided for @backTooltip.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get backTooltip;

  /// No description provided for @detailCountry.
  ///
  /// In es, this message translates to:
  /// **'País'**
  String get detailCountry;

  /// No description provided for @detailOrigin.
  ///
  /// In es, this message translates to:
  /// **'Origen'**
  String get detailOrigin;

  /// No description provided for @detailCoat.
  ///
  /// In es, this message translates to:
  /// **'Pelaje'**
  String get detailCoat;

  /// No description provided for @detailPattern.
  ///
  /// In es, this message translates to:
  /// **'Patrón'**
  String get detailPattern;

  /// No description provided for @detailSerial.
  ///
  /// In es, this message translates to:
  /// **'ID {serial}'**
  String detailSerial(String serial);

  /// No description provided for @detailLoading.
  ///
  /// In es, this message translates to:
  /// **'Buscando la raza…'**
  String get detailLoading;

  /// No description provided for @detailNotFoundTitle.
  ///
  /// In es, this message translates to:
  /// **'Esa raza no está en el directorio'**
  String get detailNotFoundTitle;

  /// No description provided for @detailNotFoundMessage.
  ///
  /// In es, this message translates to:
  /// **'Puede que el enlace esté mal escrito. Vuelve al listado y búscala allí.'**
  String get detailNotFoundMessage;

  /// No description provided for @detailGoToDirectory.
  ///
  /// In es, this message translates to:
  /// **'Ir al directorio'**
  String get detailGoToDirectory;

  /// No description provided for @detailCopyLink.
  ///
  /// In es, this message translates to:
  /// **'Copiar enlace'**
  String get detailCopyLink;

  /// No description provided for @detailLinkCopied.
  ///
  /// In es, this message translates to:
  /// **'Enlace copiado'**
  String get detailLinkCopied;

  /// No description provided for @detailAvatarSemantics.
  ///
  /// In es, this message translates to:
  /// **'Avatar de {name}'**
  String detailAvatarSemantics(String name);

  /// No description provided for @detailPetHint.
  ///
  /// In es, this message translates to:
  /// **'Tócalo para acariciarlo'**
  String get detailPetHint;

  /// No description provided for @factTitle.
  ///
  /// In es, this message translates to:
  /// **'Dato curioso'**
  String get factTitle;

  /// No description provided for @factLoading.
  ///
  /// In es, this message translates to:
  /// **'Consultando la red felina…'**
  String get factLoading;

  /// No description provided for @factAnother.
  ///
  /// In es, this message translates to:
  /// **'Otro dato'**
  String get factAnother;

  /// No description provided for @factLive.
  ///
  /// In es, this message translates to:
  /// **'En vivo'**
  String get factLive;

  /// No description provided for @factSaved.
  ///
  /// In es, this message translates to:
  /// **'Guardado'**
  String get factSaved;

  /// No description provided for @factSavedHint.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión: es un dato que ya habías visto.'**
  String get factSavedHint;

  /// No description provided for @factError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos traer un dato curioso.'**
  String get factError;

  /// No description provided for @factLanguage.
  ///
  /// In es, this message translates to:
  /// **'Los datos llegan en inglés desde la API.'**
  String get factLanguage;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @settingsSound.
  ///
  /// In es, this message translates to:
  /// **'Efectos de sonido'**
  String get settingsSound;

  /// No description provided for @settingsSoundDescription.
  ///
  /// In es, this message translates to:
  /// **'Respetan el modo silencio y no pausan tu música.'**
  String get settingsSoundDescription;

  /// No description provided for @settingsDailyBreed.
  ///
  /// In es, this message translates to:
  /// **'Raza del día'**
  String get settingsDailyBreed;

  /// No description provided for @settingsDailyBreedDescription.
  ///
  /// In es, this message translates to:
  /// **'Una notificación local cada día a las {time} con una raza del directorio.'**
  String settingsDailyBreedDescription(String time);

  /// No description provided for @settingsTestNotification.
  ///
  /// In es, this message translates to:
  /// **'Enviar notificación de prueba'**
  String get settingsTestNotification;

  /// No description provided for @settingsTestNotificationSent.
  ///
  /// In es, this message translates to:
  /// **'Llega en unos segundos. Puedes salir de la app para verla.'**
  String get settingsTestNotificationSent;

  /// No description provided for @settingsNotificationsDenied.
  ///
  /// In es, this message translates to:
  /// **'Las notificaciones de NekoDex están desactivadas en el sistema.'**
  String get settingsNotificationsDenied;

  /// No description provided for @settingsOpenSystemSettings.
  ///
  /// In es, this message translates to:
  /// **'Abrir ajustes'**
  String get settingsOpenSystemSettings;

  /// No description provided for @settingsCache.
  ///
  /// In es, this message translates to:
  /// **'Caché del directorio'**
  String get settingsCache;

  /// No description provided for @settingsCacheSummary.
  ///
  /// In es, this message translates to:
  /// **'{breeds} razas · {pages} páginas · {age}'**
  String settingsCacheSummary(int breeds, int pages, String age);

  /// No description provided for @settingsCacheEmpty.
  ///
  /// In es, this message translates to:
  /// **'Vacía'**
  String get settingsCacheEmpty;

  /// No description provided for @settingsCachePolicy.
  ///
  /// In es, this message translates to:
  /// **'Fresca 5 min · se revalida hasta 7 días · luego se descarta'**
  String get settingsCachePolicy;

  /// No description provided for @settingsClearCache.
  ///
  /// In es, this message translates to:
  /// **'Borrar caché'**
  String get settingsClearCache;

  /// No description provided for @settingsCacheCleared.
  ///
  /// In es, this message translates to:
  /// **'Caché borrada. El directorio se recargará desde la API.'**
  String get settingsCacheCleared;

  /// No description provided for @settingsPerformanceOverlay.
  ///
  /// In es, this message translates to:
  /// **'Overlay de rendimiento'**
  String get settingsPerformanceOverlay;

  /// No description provided for @settingsPerformanceOverlayDescription.
  ///
  /// In es, this message translates to:
  /// **'Muestra las gráficas de frames de la GPU y la UI.'**
  String get settingsPerformanceOverlayDescription;

  /// No description provided for @settingsAbout.
  ///
  /// In es, this message translates to:
  /// **'Datos de catfact.ninja · v{version}'**
  String settingsAbout(String version);

  /// No description provided for @notificationChannelName.
  ///
  /// In es, this message translates to:
  /// **'Raza del día'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In es, this message translates to:
  /// **'Una raza del directorio cada día.'**
  String get notificationChannelDescription;

  /// No description provided for @notificationBreedTitle.
  ///
  /// In es, this message translates to:
  /// **'Raza del día: {name}'**
  String notificationBreedTitle(String name);

  /// No description provided for @notificationBreedBody.
  ///
  /// In es, this message translates to:
  /// **'{country} · pelaje {coat}. Toca para ver su ficha.'**
  String notificationBreedBody(String country, String coat);

  /// No description provided for @splashSkip.
  ///
  /// In es, this message translates to:
  /// **'Toca para saltar'**
  String get splashSkip;

  /// No description provided for @routeNotFoundTitle.
  ///
  /// In es, this message translates to:
  /// **'Ruta desconocida'**
  String get routeNotFoundTitle;

  /// No description provided for @routeNotFoundMessage.
  ///
  /// In es, this message translates to:
  /// **'No hay nada en {path}.'**
  String routeNotFoundMessage(String path);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
