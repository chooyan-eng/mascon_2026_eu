import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class ExistsVsExecutesSlide extends FlutterDeckSlideWidget {
  const ExistsVsExecutesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/exists-vs-executes',
          title: '10. Exists ≠ executes',
          steps: 2,
          speakerNotes: '- Existing in the pub cache and actually running are different things.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigText('Malicious code exists on my machine', fontSize: 56),
            SizedBox(height: 24),
            BigText('≠', fontSize: 96, accent: true),
            SizedBox(height: 24),
            BigText('Malicious code executes on my machine', fontSize: 56),
            SizedBox(height: 80),
            Reveal(step: 2, child: BigText('When can a package actually execute code?', fontSize: 52, accent: true)),
          ],
        ),
      ),
    );
  }
}
