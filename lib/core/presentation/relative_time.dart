import 'package:cat_directory_app/l10n/l10n.dart';

/// "hace 5 minutos", "hace 2 horas"... para decir de cuando es la cache.
String relativeAge(AppLocalizations l10n, DateTime? moment, {DateTime? now}) {
  if (moment == null) return l10n.ageJustNow;
  final age = (now ?? DateTime.now()).difference(moment);
  if (age.inMinutes < 1) return l10n.ageJustNow;
  if (age.inHours < 1) return l10n.ageMinutes(age.inMinutes);
  if (age.inDays < 1) return l10n.ageHours(age.inHours);
  return l10n.ageDays(age.inDays);
}
