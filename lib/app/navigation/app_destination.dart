import 'package:flutter/material.dart';
import 'package:poket/l10n/generated/app_localizations.dart';

enum AppDestination {
  home('/'),
  transactions('/transactions'),
  tax('/tax'),
  wallets('/wallets'),
  settings('/settings');

  const AppDestination(this.routeName);

  final String routeName;

  String label(AppLocalizations l10n) => switch (this) {
    home => l10n.home,
    transactions => l10n.transactions,
    tax => l10n.tax,
    wallets => l10n.wallets,
    settings => l10n.settings,
  };

  IconData get icon => switch (this) {
    home => Icons.home_outlined,
    transactions => Icons.receipt_long_outlined,
    tax => Icons.account_balance_outlined,
    wallets => Icons.account_balance_wallet_outlined,
    settings => Icons.settings_outlined,
  };

  static AppDestination fromRouteName(String? routeName) => values.firstWhere(
    (destination) => destination.routeName == routeName,
    orElse: () => home,
  );
}
