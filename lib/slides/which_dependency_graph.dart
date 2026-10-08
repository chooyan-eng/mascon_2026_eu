import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class WhichDependencyGraphSlide extends FlutterDeckSlideWidget {
  const WhichDependencyGraphSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/which-dependency-graph',
          title: '30. Which dependency graph?',
          steps: 3,
          speakerNotes:
              '- Pinned plugin version + dynamic Android dependency inside it can change the final AAR.\n'
              '- A hook URL is not pinned by pubspec.lock at all.\n'
              '- [NEEDS VERIFICATION] native dependency locking / verification details.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO(verify): native dependency locking / verification details (docs/slides.md #30).
    const rows = [
      ('Dart', 'pubspec.lock'),
      ('Android', 'Gradle / Maven dependency resolution'),
      ('iOS CocoaPods', 'Podfile.lock'),
      ('iOS SwiftPM', 'Package.resolved'),
      ('Build hook external downloads', 'yet another artifact resolution path'),
    ];
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BigText('"We locked our dependencies."', fontSize: 64),
            const SizedBox(height: 48),
            Reveal(
              step: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (i, (eco, lock)) in rows.indexed)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 520,
                            child: Text(
                              eco,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 30,
                                color: i == rows.length - 1
                                    ? DeckColors.accent
                                    : DeckColors.onSurface,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: DeckColors.muted,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 620,
                            child: Node(
                              lock,
                              fontSize: 26,
                              accent: i == rows.length - 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            const Reveal(
              step: 3,
              child: BigText(
                'Which dependency graph?',
                fontSize: 64,
                accent: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
