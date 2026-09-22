import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

/// Color palette for the deck (dark theme only).
abstract final class DeckColors {
  static const background = Color(0xFF0B1220);
  static const surface = Color(0xFF162036);
  static const surfaceAlt = Color(0xFF1E2A44);
  static const onSurface = Color(0xFFE6EAF2);
  static const muted = Color(0xFF9AA5B8);
  static const accent = Color(0xFFFFB74D);
  static const onAccent = Color(0xFF1A1200);
  static const danger = Color(0xFFFF6E6E);
  static const ok = Color(0xFF7BD88F);
}

FlutterDeckThemeData buildDeckTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: DeckColors.accent,
    brightness: Brightness.dark,
  ).copyWith(
    surface: DeckColors.background,
    onSurface: DeckColors.onSurface,
    primary: DeckColors.accent,
    onPrimary: DeckColors.onAccent,
    secondary: DeckColors.surfaceAlt,
    onSecondary: DeckColors.onSurface,
  );

  final material = ThemeData.from(colorScheme: colorScheme, useMaterial3: true);

  return FlutterDeckThemeData.fromTheme(material).copyWith(
    splitSlideTheme: const FlutterDeckSplitSlideThemeData(
      leftBackgroundColor: DeckColors.background,
      leftColor: DeckColors.onSurface,
      rightBackgroundColor: DeckColors.surface,
      rightColor: DeckColors.onSurface,
    ),
    quoteSlideTheme: const FlutterDeckQuoteSlideThemeData(
      quoteTextStyle: TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 1.25,
      ),
      attributionTextStyle: TextStyle(fontSize: 32, color: DeckColors.muted),
    ),
    bigFactSlideTheme: const FlutterDeckBigFactSlideThemeData(
      titleTextStyle: TextStyle(
        fontSize: 360,
        fontWeight: FontWeight.w800,
        color: DeckColors.accent,
      ),
      subtitleTextStyle: TextStyle(fontSize: 44, color: DeckColors.onSurface),
    ),
    titleSlideTheme: const FlutterDeckTitleSlideThemeData(
      titleTextStyle: TextStyle(fontSize: 76, fontWeight: FontWeight.w700, height: 1.15),
      subtitleTextStyle: TextStyle(fontSize: 36, color: DeckColors.muted),
    ),
    headerTheme: const FlutterDeckHeaderThemeData(
      color: DeckColors.onSurface,
      textStyle: TextStyle(fontSize: 52, fontWeight: FontWeight.w600),
    ),
    bulletListTheme: const FlutterDeckBulletListThemeData(
      color: DeckColors.onSurface,
      textStyle: TextStyle(fontSize: 40, height: 1.3),
    ),
    footerTheme: const FlutterDeckFooterThemeData(
      slideNumberColor: DeckColors.muted,
      socialHandleColor: DeckColors.muted,
    ),
  );
}
