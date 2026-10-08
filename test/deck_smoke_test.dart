import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mascon_eu_2026/main.dart';
import 'package:mascon_eu_2026/widgets/design.dart';

/// Walks through every slide and step and fails on any exception.
///
/// RenderFlex overflow is ignored: tests render with the Ahem fallback font
/// (google_fonts cannot fetch in tests), whose glyph metrics are much wider
/// than Figtree / Martian Mono, so overflow here does not reflect the real
/// deck. Check overflow visually at 1920x1080 instead.
void main() {
  testWidgets('every slide and step renders without errors', (tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    deckLoopingAnimations = false;
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // Swallow overflow errors before the framework records them; anything
    // else still surfaces through takeException below.
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('RenderFlex overflowed')) return;
      original?.call(details);
    };
    addTearDown(() => FlutterError.onError = original);

    final errors = <String>[];
    void collect(String location) {
      final error = tester.takeException();
      if (error == null) return;
      errors.add('after $location -> ${'$error'.split('\n').first}');
    }

    await tester.pumpWidget(const MasconDeck());
    await tester.pumpAndSettle();
    collect('startup');

    var guard = 0;
    String? lastLocation;
    while (guard++ < 200) {
      final context = tester.element(find.byType(FlutterDeckSlide).last);
      final deck = context.flutterDeck;
      final location = '${deck.slideNumber}:${deck.stepNumber}';
      if (location == lastLocation) break;
      lastLocation = location;
      deck.next();
      await tester.pumpAndSettle(const Duration(milliseconds: 50));
      collect(location);
    }
    // Flush the staged-entrance timers of the last slide.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    collect('teardown');

    expect(errors, isEmpty, reason: errors.join('\n'));
    expect(lastLocation, startsWith('29:'));
  });
}
