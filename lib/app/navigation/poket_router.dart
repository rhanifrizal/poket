import 'package:flutter/material.dart';
import 'package:poket/app/navigation/app_destination.dart';
import 'package:poket/app/navigation/responsive_navigation_shell.dart';

class PoketRouteInformationParser
    extends RouteInformationParser<AppDestination> {
  @override
  Future<AppDestination> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final route = uri.fragment.startsWith('/') ? uri.fragment : uri.path;
    return AppDestination.fromRouteName(route);
  }

  @override
  RouteInformation restoreRouteInformation(AppDestination configuration) {
    return RouteInformation(uri: Uri.parse(configuration.routeName));
  }
}

class PoketRouterDelegate extends RouterDelegate<AppDestination>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppDestination> {
  PoketRouterDelegate({
    required this.currentDestination,
    required this.onDestinationSelected,
  });

  final AppDestination Function() currentDestination;
  final ValueChanged<AppDestination> onDestinationSelected;

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  AppDestination get currentConfiguration => currentDestination();

  void refreshFromState() => notifyListeners();

  @override
  Future<void> setNewRoutePath(AppDestination configuration) async {
    onDestinationSelected(configuration);
  }

  @override
  Widget build(BuildContext context) {
    final destination = currentConfiguration;

    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage<void>(
          key: ValueKey(destination.routeName),
          name: destination.routeName,
          child: ResponsiveNavigationShell(
            onDestinationSelected: onDestinationSelected,
          ),
        ),
      ],
      onDidRemovePage: (_) {},
    );
  }
}
