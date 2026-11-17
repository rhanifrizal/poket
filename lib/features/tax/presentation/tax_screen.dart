import 'package:flutter/material.dart';
import 'package:poket/app/widgets/feature_placeholder.dart';
import 'package:poket/l10n/generated/app_localizations.dart';

class TaxScreen extends StatelessWidget {
  const TaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FeaturePlaceholder(
      destinationKey: 'tax',
      icon: Icons.account_balance_outlined,
      title: l10n.comingSoonTitle,
      message: l10n.comingSoonBody,
    );
  }
}
