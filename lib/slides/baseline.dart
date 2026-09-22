import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class BaselineSlide extends FlutterDeckSlideWidget {
  const BaselineSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/baseline',
          title: '24. Baseline',
          steps: 2,
          header: FlutterDeckHeaderConfiguration(
            title: 'Before looking for malicious behavior, learn the normal baseline',
          ),
          speakerNotes: '- A dangerous API search is not enough. Understand the platform first.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DeckTable(
              columns: ['Behavior', 'Verdict'],
              fontSize: 30,
              columnWidths: {0: FlexColumnWidth(3), 1: FlexColumnWidth(1.2)},
              rows: [
                ['Analyzer plugin suddenly downloads a native binary', 'Unusual'],
                ['Native build hook downloads a native library', 'Plausible legitimate use'],
                ['Gradle native plugin starts a compiler process', 'Ordinary'],
                ['Unrelated formatter reads ~/.ssh', 'Unusual'],
              ],
            ),
            const SizedBox(height: 56),
            const Reveal(
              step: 2,
              child: BigText(
                'The more powerful behavior is legitimate for a feature, '
                'the weaker that behavior becomes as a detection signal.',
                fontSize: 40,
                accent: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
