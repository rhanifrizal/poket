import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poket/app/navigation/app_destination.dart';
import 'package:poket/app/navigation/navigation_provider.dart';
import 'package:poket/features/home/presentation/home_screen.dart';
import 'package:poket/features/settings/presentation/settings_screen.dart';
import 'package:poket/features/tax/presentation/tax_screen.dart';
import 'package:poket/features/transactions/presentation/transactions_screen.dart';
import 'package:poket/features/wallets/presentation/wallets_screen.dart';
import 'package:poket/l10n/generated/app_localizations.dart';

class ResponsiveNavigationShell extends ConsumerWidget {
  const ResponsiveNavigationShell({
    required this.onDestinationSelected,
    super.key,
  });

  final ValueChanged<AppDestination> onDestinationSelected;

  static const compactBreakpoint = 600.0;
  static const extendedRailBreakpoint = 1200.0;
  static const contentMaxWidth = 1080.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDestinationProvider);
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < compactBreakpoint) {
          return _buildCompactLayout(context, selected, l10n);
        }
        return _buildWideLayout(
          context,
          selected,
          l10n,
          extended: constraints.maxWidth >= extendedRailBreakpoint,
        );
      },
    );
  }

  Widget _buildCompactLayout(
    BuildContext context,
    AppDestination selected,
    AppLocalizations l10n,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text(selected.label(l10n))),
      body: _destinationContent(selected),
      bottomNavigationBar: Semantics(
        container: true,
        label: l10n.navigationLabel,
        child: NavigationBar(
          key: const ValueKey('responsive_navigation_bar'),
          selectedIndex: selected.index,
          onDestinationSelected: (index) =>
              onDestinationSelected(AppDestination.values[index]),
          destinations: [
            for (final destination in AppDestination.values)
              NavigationDestination(
                key: ValueKey('destination_${destination.name}'),
                icon: Icon(destination.icon),
                selectedIcon: Icon(_selectedIcon(destination)),
                label: destination.label(l10n),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(
    BuildContext context,
    AppDestination selected,
    AppLocalizations l10n, {
    required bool extended,
  }) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Semantics(
              container: true,
              label: l10n.navigationLabel,
              child: NavigationRail(
                key: const ValueKey('responsive_navigation_rail'),
                selectedIndex: selected.index,
                extended: extended,
                labelType: extended
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.selected,
                onDestinationSelected: (index) =>
                    onDestinationSelected(AppDestination.values[index]),
                destinations: [
                  for (final destination in AppDestination.values)
                    NavigationRailDestination(
                      icon: Icon(destination.icon),
                      selectedIcon: Icon(_selectedIcon(destination)),
                      label: Text(destination.label(l10n)),
                    ),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: contentMaxWidth),
                  child: Scaffold(
                    appBar: AppBar(title: Text(selected.label(l10n))),
                    body: _destinationContent(selected),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _destinationContent(AppDestination selected) => switch (selected) {
    AppDestination.home => const HomeScreen(),
    AppDestination.transactions => const TransactionsScreen(),
    AppDestination.tax => const TaxScreen(),
    AppDestination.wallets => const WalletsScreen(),
    AppDestination.settings => const SettingsScreen(),
  };

  IconData _selectedIcon(AppDestination destination) => switch (destination) {
    AppDestination.home => Icons.home,
    AppDestination.transactions => Icons.receipt_long,
    AppDestination.tax => Icons.account_balance,
    AppDestination.wallets => Icons.account_balance_wallet,
    AppDestination.settings => Icons.settings,
  };
}
