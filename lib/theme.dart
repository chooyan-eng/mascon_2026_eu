import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:google_fonts/google_fonts.dart';

/// Color palette for the deck.
///
/// Values come from docs/design_handoff_mascon_deck/README.md (Claude Design
/// handoff). Single gold accent; "danger" is expressed with gold, not red.
abstract final class DeckColors {
  static const background = Color(0xFF1C1A19);
  static const text = Color(0xFFF8F4F4); // main text
  static const sub = Color(0xFFD7D3D3); // secondary text
  static const faint = Color(0xFFBAB6B6); // supporting text
  static const faintest = Color(0xFF9B9797); // footer, labels
  static const gray = Color(0xFF7D7979); // upstream arrow, quiet strokes
  static const line = Color(0xFF605D5D); // non-emphasized borders
  static const rule = Color(0xFF444141); // table rules, sunk elements
  static const accent = Color(0xFFE1AD66); // gold
  static const accentDark = Color(0xFF7D5411); // gold underline
  static const codeBackground = Color(0xFF151312);

  // Kept for hidden (non-projected) legacy slides only.
  static const surface = Color(0xFF262322);
  static const surfaceAlt = Color(0xFF33302E);
  static const onSurface = text;
  static const muted = faintest;
  static const onAccent = Color(0xFF1A1200);
  static const danger = accent;
  static const ok = accent;
}

/// Figtree text style. Light (300) is the default weight of the deck.
TextStyle fig(
  double size, {
  FontWeight weight = FontWeight.w300,
  Color color = DeckColors.text,
  bool italic = false,
  double? height,
  double? letterSpacing,
}) {
  return GoogleFonts.figtree(
    fontSize: size,
    fontWeight: weight,
    color: color,
    fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// Martian Mono text style: kickers, handles, file names, commands,
/// package names, code and numbers.
TextStyle mono(
  double size, {
  Color color = DeckColors.text,
  double? letterSpacing,
  double? height,
}) {
  return GoogleFonts.martianMono(
    fontSize: size,
    fontWeight: FontWeight.w400,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

FlutterDeckThemeData buildDeckTheme() {
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: DeckColors.accent,
        brightness: Brightness.dark,
      ).copyWith(
        surface: DeckColors.background,
        onSurface: DeckColors.text,
        primary: DeckColors.accent,
        onPrimary: DeckColors.onAccent,
        secondary: DeckColors.rule,
        onSecondary: DeckColors.text,
      );

  final material = ThemeData.from(colorScheme: colorScheme, useMaterial3: true);

  return FlutterDeckThemeData.fromTheme(material).copyWith(
    textTheme: FlutterDeckTextTheme(
      title: fig(88),
      subtitle: fig(36, color: DeckColors.faint),
      bodyLarge: fig(40),
      bodyMedium: fig(32),
      bodySmall: fig(28),
      display: fig(130, height: 1.02, letterSpacing: -0.03 * 130),
      header: fig(88, height: 1.0),
    ),
    footerTheme: FlutterDeckFooterThemeData(
      slideNumberColor: DeckColors.faintest,
      socialHandleColor: DeckColors.faintest,
      slideNumberTextStyle: fig(24, color: DeckColors.faintest),
      socialHandleTextStyle: fig(24, color: DeckColors.faintest),
    ),
  );
}
