import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Provenance: the source you can read is not necessarily what your build
/// consumes.
class WhatBuildConsumesSlide extends FlutterDeckSlideWidget {
  const WhatBuildConsumesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/what-build-consumes',
          title: '17. Provenance',
          steps: 2,
          speakerNotes:
              '- Reading the GitHub repository is not enough.\n'
              "- Don't audit what looks like your dependency. Audit what your build actually consumes.\n"
              '- What to check differs per ecosystem.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        pageNumber: '17',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Enter(
              child: Text(
                'Is the source on GitHub\nwhat my build actually uses?',
                textAlign: TextAlign.center,
                style: fig(50, height: 1.2),
              ),
            ),
            const SizedBox(height: 64),
            Enter(
              step: 2,
              child: Text(
                'No.',
                style: fig(140, color: DeckColors.accent, height: 1),
              ),
            ),
            const SizedBox(height: 64),
            Enter(
              step: 2,
              delayMs: 500,
              child: Column(
                children: [
                  Text(
                    'Audit what your build actually consumes.',
                    style: fig(40, color: DeckColors.sub),
                  ),
                  const SizedBox(height: 20),
                  Text('provenance', style: mono(32, color: DeckColors.accent)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
