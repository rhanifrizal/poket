import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poket/app/navigation/app_destination.dart';
import 'package:poket/app/navigation/navigation_provider.dart';
import 'package:poket/app/navigation/poket_router.dart';
import 'package:poket/app/theme/poket_theme.dart';
import 'package:poket/l10n/generated/app_localizations.dart';

class PoketApp extends ConsumerStatefulWidget {
  const PoketApp({this.locale, super.key});

  final Locale? locale;

  @override
  ConsumerState<PoketApp> createState() => _PoketAppState();
}

class _PoketAppState extends ConsumerState<PoketApp> {
  late final PoketRouterDelegate _routerDelegate = PoketRouterDelegate(
    currentDestination: () => ref.read(selectedDestinationProvider),
    onDestinationSelected: (destination) =>
        ref.read(selectedDestinationProvider.notifier).select(destination),
  );

  @override
  Widget build(BuildContext context) {
    ref.listen<AppDestination>(selectedDestinationProvider, (_, _) {
      _routerDelegate.refreshFromState();
    });

    return MaterialApp.router(
      locale: widget.locale,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: PoketTheme.light,
      darkTheme: PoketTheme.dark,
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routeInformationParser: PoketRouteInformationParser(),
      routerDelegate: _routerDelegate,
    );
  }

  @override
  void dispose() {
    _routerDelegate.dispose();
    super.dispose();
  }
}
