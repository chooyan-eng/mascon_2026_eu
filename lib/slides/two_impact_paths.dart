import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class TwoImpactPathsSlide extends FlutterDeckSlideWidget {
  const TwoImpactPathsSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/two-impact-paths',
          title: '09. Two impact paths',
          steps: 2,
          speakerNotes:
              '- Even if nothing bad happens on the developer machine, '
              'malicious runtime code can still reach the app.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const _Path(
        step: 1,
        title: 'Developer / CI compromise',
        items: [
          'Malicious package',
          'Build-time / development-time execution',
          'Developer machine / CI',
          'Credential theft, source modification, artifact tampering, exfiltration',
        ],
      ),
      rightBuilder: (context) => const _Path(
        step: 2,
        title: 'End-user compromise',
        items: [
          'Malicious runtime code',
          'Compiled / bundled into the app',
          'APK / IPA',
          'End-user device',
        ],
      ),
    );
  }
}

class _Path extends StatelessWidget {
  const _Path({required this.step, required this.title, required this.items});

  final int step;
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Reveal(
      step: step,
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigText(title, fontSize: 44, accent: true),
            const SizedBox(height: 40),
            ChainColumn(
              items: items,
              fontSize: 28,
              nodeWidth: 640,
              dangerIndexes: {0, items.length - 1},
            ),
          ],
        ),
      ),
    );
  }
}
