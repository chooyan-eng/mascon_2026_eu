import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class AllOfThemSlide extends FlutterDeckSlideWidget {
  const AllOfThemSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/all-of-them',
          title: '34. All 606?',
          steps: 2,
          speakerNotes:
              '- Honest answer: no.\n'
              '- Prioritize high-risk mechanisms, enumerate surfaces mechanically, '
              'classify source / binary / download, keep the risk decision human.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigText('Can we do this for all 606 dependencies?', fontSize: 60, accent: true),
            SizedBox(height: 48),
            Reveal(
              step: 2,
              child: ChainColumn(
                fontSize: 26,
                gap: 2,
                nodeWidth: 860,
                accentIndexes: {5},
                items: [
                  'One dependency',
                  'Obsessively investigate it',
                  'Learn which questions matter',
                  "Realize this doesn't scale",
                  'Use tooling / AI to apply those questions broadly',
                  'A human chooses where deeper assurance is needed',
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
