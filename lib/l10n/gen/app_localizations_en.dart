// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'NekoDex';

  @override
  String get directoryTagline => 'Feline directory';

  @override
  String directoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count breeds on the grid',
      one: '1 breed on the grid',
      zero: 'No breeds',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'search_breed…';

  @override
  String get searchLabel => 'Search breeds by name';

  @override
  String get searchClear => 'Clear search';

  @override
  String searchResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches',
      one: '1 match',
      zero: 'No matches',
    );
    return '$_temp0';
  }

  @override
  String searchScope(int count) {
    return 'Searching $count loaded breeds';
  }

  @override
  String get searchLoadMore => 'Load more breeds';

  @override
  String get statusLive => 'Live';

  @override
  String get statusCache => 'Cache';

  @override
  String get statusOffline => 'No signal';

  @override
  String get statusSyncing => 'Syncing';

  @override
  String statusSemantics(String status) {
    return 'Data status: $status';
  }

  @override
  String bannerOffline(String age) {
    return 'Offline. Showing data saved $age.';
  }

  @override
  String get bannerOfflineEmpty => 'No internet connection.';

  @override
  String bannerRetrying(int attempt, int max) {
    return 'Reconnecting… attempt $attempt of $max';
  }

  @override
  String bannerStale(String age) {
    return 'Data saved $age. Updating in the background…';
  }

  @override
  String get ageJustNow => 'just now';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String breedTileSemantics(String name, String country) {
    return '$name. Country: $country.';
  }

  @override
  String get breedTileHint => 'open profile';

  @override
  String get unknownCountry => 'Unknown country';

  @override
  String get unknownValue => 'No data';

  @override
  String get loadingBreeds => 'Loading breeds';

  @override
  String get paginationLoading => 'Loading more breeds…';

  @override
  String get paginationError =>
      'Couldn\'t load the next page. Your list is still here.';

  @override
  String get retry => 'Retry';

  @override
  String endOfList(int count) {
    return 'End of directory · $count breeds';
  }

  @override
  String get errorOfflineTitle => 'No connection to the cat grid';

  @override
  String get errorOfflineMessage =>
      'There\'s no saved data on this phone yet. We\'ll retry on our own when you\'re back online.';

  @override
  String get errorServerTitle => 'The API isn\'t answering';

  @override
  String get errorServerMessage =>
      'The cat server is having a bad day. We already retried a few times; try again in a moment.';

  @override
  String get errorRateLimitedTitle => 'Too many requests';

  @override
  String get errorRateLimitedMessage =>
      'The API needs a breather. Wait a few seconds and retry.';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericMessage =>
      'We couldn\'t load the directory. Try again in a moment.';

  @override
  String emptySearchTitle(String query) {
    return 'No cat answers to “$query”';
  }

  @override
  String get emptySearchMessage =>
      'Search covers the breeds already loaded. Load more or try another name.';

  @override
  String get noticeShowingCache => 'Offline: showing saved data.';

  @override
  String get noticeRefreshFailed =>
      'Couldn\'t refresh. The list is still available.';

  @override
  String get noticeBackOnline => 'Back online';

  @override
  String get noticeRefreshed => 'Directory updated';

  @override
  String get noticeRateLimited =>
      'The API needs a breather. Retry in a few seconds.';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get backTooltip => 'Back';

  @override
  String get detailCountry => 'Country';

  @override
  String get detailOrigin => 'Origin';

  @override
  String get detailCoat => 'Coat';

  @override
  String get detailPattern => 'Pattern';

  @override
  String detailSerial(String serial) {
    return 'ID $serial';
  }

  @override
  String get detailLoading => 'Looking up the breed…';

  @override
  String get detailNotFoundTitle => 'That breed isn\'t in the directory';

  @override
  String get detailNotFoundMessage =>
      'The link might be misspelled. Go back to the list and search there.';

  @override
  String get detailGoToDirectory => 'Go to directory';

  @override
  String get detailCopyLink => 'Copy link';

  @override
  String get detailLinkCopied => 'Link copied';

  @override
  String detailAvatarSemantics(String name) {
    return 'Avatar of $name';
  }

  @override
  String get detailPetHint => 'Tap to pet';

  @override
  String get factTitle => 'Fun fact';

  @override
  String get factLoading => 'Querying the cat grid…';

  @override
  String get factAnother => 'Another fact';

  @override
  String get factLive => 'Live';

  @override
  String get factSaved => 'Saved';

  @override
  String get factSavedHint => 'Offline: this is a fact you\'ve seen before.';

  @override
  String get factError => 'We couldn\'t fetch a fun fact.';

  @override
  String get factLanguage => 'Facts come in English from the API.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get settingsSound => 'Sound effects';

  @override
  String get settingsSoundDescription =>
      'They respect silent mode and never pause your music.';

  @override
  String get settingsDailyBreed => 'Breed of the day';

  @override
  String settingsDailyBreedDescription(String time) {
    return 'A local notification every day at $time with a breed from the directory.';
  }

  @override
  String get settingsTestNotification => 'Send a test notification';

  @override
  String get settingsTestNotificationSent =>
      'Sent. Tap it to open the breed profile.';

  @override
  String get settingsNotificationsDenied =>
      'NekoDex notifications are turned off in system settings.';

  @override
  String get settingsOpenSystemSettings => 'Open settings';

  @override
  String get settingsCache => 'Directory cache';

  @override
  String settingsCacheSummary(int breeds, int pages, String age) {
    return '$breeds breeds · $pages pages · $age';
  }

  @override
  String get settingsCacheEmpty => 'Empty';

  @override
  String get settingsCachePolicy =>
      'Fresh for 5 min · revalidated up to 7 days · then discarded';

  @override
  String get settingsClearCache => 'Clear cache';

  @override
  String get settingsCacheCleared =>
      'Cache cleared. The directory will reload from the API.';

  @override
  String get settingsPerformanceOverlay => 'Performance overlay';

  @override
  String get settingsPerformanceOverlayDescription =>
      'Shows the GPU and UI frame charts.';

  @override
  String settingsAbout(String version) {
    return 'Data from catfact.ninja · v$version';
  }

  @override
  String get notificationChannelName => 'Breed of the day';

  @override
  String get notificationChannelDescription =>
      'One breed from the directory every day.';

  @override
  String notificationBreedTitle(String name) {
    return 'Breed of the day: $name';
  }

  @override
  String notificationBreedBody(String country, String coat) {
    return '$country · $coat coat. Tap to see its profile.';
  }

  @override
  String get splashSkip => 'Tap to skip';

  @override
  String get routeNotFoundTitle => 'Unknown route';

  @override
  String routeNotFoundMessage(String path) {
    return 'There\'s nothing at $path.';
  }

  @override
  String get settingsNoBreedsYet =>
      'No breeds saved yet. Open the directory while online and try again.';

  @override
  String get settingsDailyBreedOn =>
      'Done: the next breed of the day is scheduled.';
}
