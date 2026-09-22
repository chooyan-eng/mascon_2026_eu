import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class EverySurfaceSlide extends FlutterDeckSlideWidget {
  const EverySurfaceSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/every-surface',
          title: '25. Same for every surface',
          speakerNotes:
              '- That was one surface out of five.\n'
              '- I read the docs, the SDK source and real packages, and built small experiments to say this much.\n'
              '- Analyzer plugins, build_runner and DevTools extensions deserve the same treatment.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.quote(
      quote:
          'That was one surface. Every other one deserves the same: '
          'understand the mechanism, understand the attack path, then choose the defense.',
      attribution: 'Analyzer plugins · build_runner · DevTools extensions · library code',
      quoteMaxLines: 4,
    );
  }
}
