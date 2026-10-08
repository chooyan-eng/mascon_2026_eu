import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mascon_eu_2026/main.dart';
import 'package:mascon_eu_2026/widgets/design.dart';

/// Captures every slide (at its last step, so all [Reveal]s are visible) as a
/// 1920x1080 PNG under test/screenshots/.
///
/// This is an export tool, not a regression test — it only runs in update
/// mode. Usage:
///
///   flutter test --update-goldens test/deck_screenshot_test.dart
///   magick test/screenshots/slide_*.png docs/deck_export.pdf
///
/// Real fonts are loaded from test/fonts/ under the exact family names that
/// google_fonts registers (e.g. `Figtree_300`), so the output matches the
/// real deck instead of the Ahem fallback used by the smoke test.
void main() {
  testWidgets('export every slide as PNG', (tester) async {
    if (!autoUpdateGoldenFiles) {
      markTestSkipped('Screenshot export only runs with --update-goldens.');
      return;
    }

    GoogleFonts.config.allowRuntimeFetching = false;
    deckLoopingAnimations = false;
    await _loadDeckFonts();

    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // Overflows would abort the capture; log them and render anyway. The
    // slide layout is fixed at 1920x1080 by slideSize, so any overflow
    // reported here exists in the real deck too — fix the slide.
    final overflows = <String>[];
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('RenderFlex overflowed')) {
        overflows.add(message.split('\n').first);
        return;
      }
      original?.call(details);
    };
    addTearDown(() => FlutterError.onError = original);

    await tester.pumpWidget(const MasconDeck());
    await tester.pumpAndSettle();

    // The number of slides is not exposed directly; walk until goToSlide
    // stops moving instead.
    var index = 1;
    while (true) {
      _deck(tester).goToSlide(index);
      await tester.pumpAndSettle();

      final deck = _deck(tester);
      if (deck.slideNumber != index) break;

      // Let real async work finish (rootBundle loads such as the dependency
      // graph JSON never complete inside the fake-async zone).
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();

      // Jump to the last step so every Reveal is visible, then flush the
      // staged-entrance timers some slides use.
      final steps = deck.configuration.steps;
      if (steps > 1) {
        deck.goToStep(steps);
        await tester.pumpAndSettle();
      }
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      await _precacheImages(tester);

      final route = deck.configuration.route.replaceAll('/', '');
      final number = '$index'.padLeft(2, '0');
      await expectLater(
        find.byType(MasconDeck),
        matchesGoldenFile('screenshots/slide_${number}_$route.png'),
      );
      for (final overflow in overflows) {
        debugPrint('OVERFLOW on slide $index ($route): $overflow');
      }
      overflows.clear();
      index++;
    }

    expect(index - 1, greaterThan(0));
    debugPrint('Exported ${index - 1} slides to test/screenshots/');
  });
}

FlutterDeck _deck(WidgetTester tester) =>
    tester.element(find.byType(FlutterDeckSlide).last).flutterDeck;

/// Decodes asset images (e.g. me_photo.jpg) which never resolve inside the
/// fake-async zone of a widget test.
Future<void> _precacheImages(WidgetTester tester) async {
  final context = tester.element(find.byType(MasconDeck));
  final images = find
      .byType(Image, skipOffstage: false)
      .evaluate()
      .map((element) => (element.widget as Image).image)
      .toList();
  await tester.runAsync(() async {
    for (final image in images) {
      await precacheImage(image, context);
    }
  });
  await tester.pumpAndSettle();
}

/// Registers the deck's real fonts under the family names google_fonts uses
/// (`<family>_<variant>`), so the golden renders with Figtree / Martian Mono.
Future<void> _loadDeckFonts() async {
  const fonts = {
    'Figtree_300': 'Figtree-Light.ttf',
    'Figtree_regular': 'Figtree-Regular.ttf',
    'Figtree_600': 'Figtree-SemiBold.ttf',
    'Figtree_700': 'Figtree-Bold.ttf',
    'Figtree_300italic': 'Figtree-LightItalic.ttf',
    'Figtree_italic': 'Figtree-Italic.ttf',
    'Figtree_600italic': 'Figtree-SemiBoldItalic.ttf',
    'Figtree_700italic': 'Figtree-BoldItalic.ttf',
    'MartianMono_regular': 'MartianMono-Regular.ttf',
  };
  for (final entry in fonts.entries) {
    final bytes = File('test/fonts/${entry.value}').readAsBytesSync();
    final loader = FontLoader(entry.key)
      ..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
  }

  // Some widgets (e.g. SpeakerInfo, deck_widgets labels) use TextStyles
  // without an explicit family, which resolve to the theme default
  // ('Roboto' on the test platform). Map that to Figtree so they render
  // with real glyphs instead of the box-shaped test font.
  final roboto = FontLoader('Roboto');
  for (final file in [
    'Figtree-Light.ttf',
    'Figtree-Regular.ttf',
    'Figtree-SemiBold.ttf',
    'Figtree-Bold.ttf',
  ]) {
    final bytes = File('test/fonts/$file').readAsBytesSync();
    roboto.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await roboto.load();
}
