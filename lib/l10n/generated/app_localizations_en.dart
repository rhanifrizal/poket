// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Poket';

  @override
  String get home => 'Home';

  @override
  String get transactions => 'Transactions';

  @override
  String get tax => 'Tax';

  @override
  String get wallets => 'Wallets';

  @override
  String get settings => 'Settings';

  @override
  String get comingSoonTitle => 'A clearer view of your money is on its way';

  @override
  String get comingSoonBody =>
      'This area is being prepared. Your financial information stays private by design.';

  @override
  String get navigationLabel => 'Primary navigation';

  @override
  String destinationContentLabel(Object destination) {
    return '$destination screen';
  }
}
