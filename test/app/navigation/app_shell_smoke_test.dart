import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poket/app/navigation/app_destination.dart';
import 'package:poket/app/navigation/poket_router.dart';
import 'package:poket/app/poket_app.dart';

void main() {
  test('parses hash-based browser routes', () async {
    final destination = await PoketRouteInformationParser()
        .parseRouteInformation(RouteInformation(uri: Uri.parse('/#/wallets')));

    expect(destination, AppDestination.wallets);
  });

  testWidgets('all primary destinations are available and selectable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: PoketApp()));

    for (final destination in [
      'home',
      'transactions',
      'tax',
      'wallets',
      'settings',
    ]) {
      expect(find.byKey(ValueKey('destination_$destination')), findsOneWidget);
    }
    expect(
      find.byKey(const ValueKey('destination_content_home')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('destination_transactions')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('destination_content_transactions')),
      findsOneWidget,
    );
  });

  testWidgets('a deep link opens its matching destination', (tester) async {
    tester.platformDispatcher.defaultRouteNameTestValue = '/tax';
    addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);

    await tester.pumpWidget(const ProviderScope(child: PoketApp()));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('destination_content_tax')),
      findsOneWidget,
    );
  });

  testWidgets('selecting a destination updates the browser route', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: PoketApp()));
    await tester.tap(find.byKey(const ValueKey('destination_transactions')));
    await tester.pumpAndSettle();

    final router = tester.widget<Router<Object>>(find.byType(Router<Object>));
    expect(
      router.routerDelegate.currentConfiguration,
      AppDestination.transactions,
    );
    expect(router.routeInformationProvider?.value.uri.path, '/transactions');
  });
}
