import 'package:flutter/material.dart';

abstract final class PoketTheme {
  static const _brandTeal = Color(0xFF28796F);
  static const _warmSurface = Color(0xFFFAF8F2);

  static final light = _buildTheme(
    brightness: Brightness.light,
    surface: _warmSurface,
  );

  static final dark = _buildTheme(
    brightness: Brightness.dark,
    surface: const Color(0xFF171C1B),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color surface,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _brandTeal,
      brightness: brightness,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: colorScheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
