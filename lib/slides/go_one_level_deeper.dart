import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class GoOneLevelDeeperSlide extends FlutterDeckSlideWidget {
  const GoOneLevelDeeperSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/go-one-level-deeper',
          title: '37. Go one level deeper',
          speakerNotes: '- Closing call to action.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigText('Go one level deeper.', fontSize: 96, accent: true),
            SizedBox(height: 64),
            BigText(
              'Pick one part of your own development environment.',
              fontSize: 36,
            ),
            SizedBox(height: 24),
            BigText(
              'Read the documentation. Look at the implementation. '
              'Create a small experiment. Use AI to help you explore it.',
              fontSize: 36,
            ),
            SizedBox(height: 24),
            BigText(
              'And ask yourself: "If this dependency was compromised, what would actually happen?"',
              fontSize: 36,
              muted: true,
            ),
          ],
        ),
      ),
    );
  }
}
