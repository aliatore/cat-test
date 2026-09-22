import 'package:cat_directory_app/features/daily_breed/daily_breed_scheduler.dart';
import 'package:cat_directory_app/l10n/l10n.dart';

DailyBreedCopy dailyBreedCopy(AppLocalizations l10n) => DailyBreedCopy(
  title: (breed) => l10n.notificationBreedTitle(breed.name),
  body: (breed) => l10n.notificationBreedBody(
    breed.country ?? l10n.unknownCountry,
    (breed.coat ?? l10n.unknownValue).toLowerCase(),
  ),
);
