import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/design_system/widgets/state_view.dart';
import 'package:cat_directory_app/l10n/l10n.dart';

/// Texto e ilustracion para cada tipo de fallo. Vive en presentacion porque
/// el dominio solo dice que paso, no como contarlo.
typedef FailureCopy = ({String title, String message, StateArt art});

FailureCopy failureCopy(AppLocalizations l10n, Failure failure) =>
    switch (failure) {
      ConnectionFailure() || TimeoutFailure() => (
        title: l10n.errorOfflineTitle,
        message: l10n.errorOfflineMessage,
        art: StateArt.offline,
      ),
      ServerFailure() => (
        title: l10n.errorServerTitle,
        message: l10n.errorServerMessage,
        art: StateArt.offline,
      ),
      RateLimitedFailure() => (
        title: l10n.errorRateLimitedTitle,
        message: l10n.errorRateLimitedMessage,
        art: StateArt.empty,
      ),
      RequestFailure() ||
      ParsingFailure() ||
      CacheFailure() ||
      NotFoundFailure() ||
      UnexpectedFailure() => (
        title: l10n.errorGenericTitle,
        message: l10n.errorGenericMessage,
        art: StateArt.offline,
      ),
    };
