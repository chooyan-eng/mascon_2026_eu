import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class AssuranceSlide extends FlutterDeckSlideWidget {
  const AssuranceSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/assurance',
          title: '33. Assurance',
          steps: 3,
          speakerNotes:
              '- Replace "is it safe" with "how much assurance do I need."',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BigText(
              'Is this package safe?',
              fontSize: 48,
              muted: true,
              strike: true,
            ),
            const SizedBox(height: 24),
            const BigText(
              'How much assurance do I need for this dependency?',
              fontSize: 56,
              accent: true,
            ),
            const SizedBox(height: 56),
            Reveal(
              step: 2,
              child: Column(
                children: [
                  Text(
                    'Not the same assurance for',
                    style: TextStyle(fontSize: 28, color: DeckColors.muted),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: const [
                      Node('Pure utility package', fontSize: 26),
                      Node('Package with a build hook', fontSize: 26),
                      Node(
                        'Package downloading an external executable',
                        fontSize: 26,
                      ),
                      Node(
                        'Package handling authentication / payment',
                        fontSize: 26,
                      ),
                      Node('Closed-source prebuilt binary', fontSize: 26),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 56),
            const Reveal(
              step: 3,
              child: BigText(
                'Review effort should be proportional to risk.',
                fontSize: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
