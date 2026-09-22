import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class DartHooksSlide extends FlutterDeckSlideWidget {
  const DartHooksSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/dart-hooks',
          title: '16. Dart hooks',
          header: FlutterDeckHeaderConfiguration(title: 'Dart hooks'),
          speakerNotes:
              '- Dart hooks include build hooks and link hooks. Today I mainly focus on build hooks.\n'
              '- [NEEDS VERIFICATION] version / lifecycle / build vs link roles.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO(verify): confirm hook version / lifecycle / build vs link roles (docs/slides.md #16).
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 640,
                child: InfoCard(title: 'Build hook', lines: ['hook/build.dart', "Today's focus"], accent: true, fontSize: 32),
              ),
              SizedBox(width: 64),
              SizedBox(
                width: 640,
                child: InfoCard(title: 'Link hook', lines: ['hook/link.dart', 'Mentioned briefly'], fontSize: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
