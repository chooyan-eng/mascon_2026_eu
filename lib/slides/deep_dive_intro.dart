import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class DeepDiveIntroSlide extends FlutterDeckSlideWidget {
  const DeepDiveIntroSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/deep-dive-intro',
          title: '15. Overview is the easy part',
          speakerNotes:
              '- Everything so far fits in ten minutes. Explaining the overview is easy.\n'
              '- Now I pick one surface and actually go deep: build hooks.\n'
              '- Watch how many new questions appear once we look at one real mechanism.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.quote(
      quote: 'The overview is the easy part. Let me pick one surface and go one level deeper.',
      attribution: 'Build hooks',
    );
  }
}
