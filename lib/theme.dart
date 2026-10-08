import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:google_fonts/google_fonts.dart';

/// Light / dark mode for the whole deck, toggled from the title slide.
/// [DeckColors] resolves against this; [MasconDeck] listens and rebuilds.
final ValueNotifier<bool> deckLightMode = ValueNotifier<bool>(false);

/// Color palette for the deck.
///
/// Dark values come from docs/design_handoff_mascon_deck/README.md, light
/// values from docs/design_handoff_mascon_deck_light/README.md (案 3a: paper
/// background, same single gold accent, layout unchanged). "Danger" is
/// expressed with gold, not red, in both modes.
abstract final class DeckColors {
  static bool get _light => deckLightMode.value;

  static Color get background =>
      _light ? const Color(0xFFF3F2F2) : const Color(0xFF1C1A19);
  static Color get text => // main text
      _light ? const Color(0xFF201F1D) : const Color(0xFFF8F4F4);
  static Color get sub => // secondary text
      _light ? const Color(0xFF444141) : const Color(0xFFD7D3D3);
  static Color get faint => // supporting text
      _light ? const Color(0xFF605D5D) : const Color(0xFFBAB6B6);
  static Color get faintest => // footer, labels
      _light ? const Color(0xFF7D7979) : const Color(0xFF9B9797);
  static Color get gray => // upstream arrow, quiet strokes
      _light ? const Color(0xFF9B9797) : const Color(0xFF7D7979);
  static Color get line => // non-emphasized borders
      _light ? const Color(0xFFBAB6B6) : const Color(0xFF605D5D);
  static Color get rule => // table rules, sunk elements
      _light ? const Color(0xFFD7D3D3) : const Color(0xFF444141);
  static Color get accent => // gold
      _light ? const Color(0xFFB68235) : const Color(0xFFE1AD66);
  static Color get accentDark => // gold underline
      _light ? const Color(0xFF8A6228) : const Color(0xFF7D5411);

  // Code blocks keep a dark panel in both modes (the light handoff is
  // inconsistent here; a dark panel stays readable on paper too).
  static Color get codeBackground =>
      _light ? const Color(0xFF2D2B2B) : const Color(0xFF151312);
  static const codeText = Color(0xFFF8F4F4);
  static const codeAccent = Color(0xFFE1AD66);

  // Kept for hidden (non-projected) legacy slides only.
  static Color get surface =>
      _light ? const Color(0xFFEAE7E7) : const Color(0xFF262322);
  static Color get surfaceAlt =>
      _light ? const Color(0xFFE0DDDD) : const Color(0xFF33302E);
  static Color get onSurface => text;
  static Color get muted => faintest;
  static Color get onAccent =>
      _light ? const Color(0xFFF8F4F4) : const Color(0xFF1A1200);
  static Color get danger => accent;
  static Color get ok => accent;
}

/// Figtree text style. Light (300) is the default weight of the deck.
TextStyle fig(
  double size, {
  FontWeight weight = FontWeight.w300,
  Color? color,
  bool italic = false,
  double? height,
  double? letterSpacing,
}) {
  return GoogleFonts.figtree(
    fontSize: size,
    fontWeight: weight,
    color: color ?? DeckColors.text,
    fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// Martian Mono text style: kickers, handles, file names, commands,
/// package names, code and numbers.
TextStyle mono(
  double size, {
  Color? color,
  double? letterSpacing,
  double? height,
}) {
  return GoogleFonts.martianMono(
    fontSize: size,
    fontWeight: FontWeight.w400,
    color: color ?? DeckColors.text,
    letterSpacing: letterSpacing,
    height: height,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

FlutterDeckThemeData buildDeckTheme() {
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: DeckColors.accent,
        brightness: deckLightMode.value ? Brightness.light : Brightness.dark,
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
