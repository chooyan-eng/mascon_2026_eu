import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascon_eu_2026/main.dart';

/// Walks through every slide and step and fails on any exception
/// (including RenderFlex overflow).
void main() {
  testWidgets('every slide and step renders without errors', (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MasconDeck());
    await tester.pumpAndSettle();

    final errors = <String>[];
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
      final error = tester.takeException();
      if (error != null) errors.add('after $location -> $error'.split('\n').first);
    }
    expect(errors, isEmpty, reason: errors.join('\n'));
    expect(lastLocation, startsWith('38:'));
  });
}
