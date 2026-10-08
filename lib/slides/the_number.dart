import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

class NumberSlide extends FlutterDeckSlideWidget {
  const NumberSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/the-number',
          title: '03. 606',
          steps: 2,
          speakerNotes:
              '- The number counts up from 0. Ask the audience: can anyone guess what this number means?\n'
              '- Measured with my dependency inspector: 283 Dart, 15 iOS, 308 Android. 86 of them are direct.\n'
              '- The next slide shows the same data as a graph.\n'
              '- Q&A prep: the Android count includes the Gradle build toolchain (about 90 artifacts) '
              'and fine-grained Maven artifacts (Firebase alone is 25); iOS counts SwiftPM packages '
              'only (15, mostly Firebase and Maps) — Apple ships the platform frameworks inside '
              'the OS, so they never appear as dependencies.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // Keep in sync with assets/dependency_graph.json (count shown on slide 04, step 2).
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        pageNumber: '03',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CountUp(
              606,
              from: 300,
              durationMs: 900,
              style: fig(
                308,
                color: DeckColors.accent,
                height: 0.85,
                letterSpacing: -0.02 * 308,
              ),
            ),
            const SizedBox(height: 40),
            Enter(
              step: 2,
              child: Text(
                'Packages my production Flutter app depends on.',
                style: fig(45, color: DeckColors.sub, italic: true),
              ),
            ),
            const SizedBox(height: 40),
            Enter(step: 2, delayMs: 350, child: const _RatioBar()),
          ],
        ),
      ),
    );
  }
}

/// Dart / iOS / Android breakdown as a bar. Dart and Android are roughly
/// proportional; the iOS segment is widened to fit its label (the exact
/// ratio does not matter here).
class _RatioBar extends StatelessWidget {
  const _RatioBar();

  static const dart = 283;
  static const ios = 15;
  static const android = 308;

  @override
  Widget build(BuildContext context) {
    TextSpan count(String name, int n) => TextSpan(
      style: fig(30, color: DeckColors.sub),
      children: [
        TextSpan(text: '$name '),
        TextSpan(
          text: '$n',
          style: fig(30, color: DeckColors.accent),
        ),
      ],
    );

    return SizedBox(
      width: 1200,
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: dart,
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: DeckColors.sub, width: 3),
                ),
              ),
              alignment: Alignment.topLeft,
              child: Text.rich(count('Dart', dart)),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 110,
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: DeckColors.accent, width: 3),
              ),
            ),
            alignment: Alignment.topCenter,
            child: Text.rich(count('iOS', ios), softWrap: false),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: android,
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: DeckColors.gray, width: 3),
                ),
              ),
              alignment: Alignment.topRight,
              child: Text.rich(count('Android', android)),
            ),
          ),
        ],
      ),
    );
  }
}
