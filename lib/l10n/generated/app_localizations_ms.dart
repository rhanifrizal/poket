// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Poket';

  @override
  String get home => 'Utama';

  @override
  String get transactions => 'Transaksi';

  @override
  String get tax => 'Cukai';

  @override
  String get wallets => 'Dompet';

  @override
  String get settings => 'Tetapan';

  @override
  String get comingSoonTitle =>
      'Paparan kewangan anda yang lebih jelas akan datang';

  @override
  String get comingSoonBody =>
      'Bahagian ini sedang disediakan. Maklumat kewangan anda direka bentuk untuk kekal peribadi.';

  @override
  String get navigationLabel => 'Navigasi utama';

  @override
  String destinationContentLabel(Object destination) {
    return 'Skrin $destination';
  }
}
