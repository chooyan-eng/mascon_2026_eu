import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class WhatBuildConsumesSlide extends FlutterDeckSlideWidget {
  const WhatBuildConsumesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/what-build-consumes',
          title: '27. What does my build consume?',
          speakerNotes: '- What to check differs per ecosystem.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.quote(
      quote: "Don't audit what looks like your dependency. Audit what your build actually consumes.",
      attribution: 'Reading the GitHub repository is not enough.',
    );
  }
}
