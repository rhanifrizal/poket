import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poket/app/poket_app.dart';

void main() {
  for (final viewport in [
    (width: 390.0, height: 844.0, navigation: 'responsive_navigation_bar'),
    (width: 768.0, height: 1024.0, navigation: 'responsive_navigation_rail'),
    (width: 1280.0, height: 900.0, navigation: 'responsive_navigation_rail'),
  ]) {
    testWidgets(
      'uses ${viewport.navigation} at ${viewport.width.toInt()} logical pixels without overflow',
      (tester) async {
        tester.view.physicalSize = Size(viewport.width, viewport.height);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ProviderScope(child: PoketApp()));

        expect(find.byKey(ValueKey(viewport.navigation)), findsOneWidget);
        expect(tester.takeException(), isNull);

        if (viewport.width == 1280) {
          final rail = tester.widget<NavigationRail>(
            find.byKey(const ValueKey('responsive_navigation_rail')),
          );
          expect(rail.extended, isTrue);
        }
      },
    );
  }

  testWidgets('destination selection is exposed through navigation semantics', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semanticsHandle = tester.ensureSemantics();

    await tester.pumpWidget(const ProviderScope(child: PoketApp()));
    expect(find.bySemanticsLabel('Primary navigation'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('destination_transactions')));
    await tester.pumpAndSettle();

    expect(
      tester
          .getSemantics(find.byKey(const ValueKey('destination_transactions')))
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    semanticsHandle.dispose();
  });

  testWidgets('phone navigation remains usable with enlarged text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const ProviderScope(child: PoketApp()));

    expect(
      find.byKey(const ValueKey('responsive_navigation_bar')),
      findsOneWidget,
    );
    expect(find.text('Transactions'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
