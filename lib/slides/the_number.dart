import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class NumberSlide extends FlutterDeckSlideWidget {
  const NumberSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/the-number',
          title: '03. 606',
          steps: 2,
          speakerNotes:
              '- Ask the audience.\n'
              '- Measured with my dependency inspector: 283 Dart, 15 iOS, 308 Android. 86 of them are direct.\n'
              '- The next slide shows the same data as a graph.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // Keep in sync with assets/dependency_graph.json (count shown on slide 04, step 2).
    return FlutterDeckSlideStepsBuilder(
      builder: (context, step) => FlutterDeckSlide.bigFact(
        title: '606',
        subtitle: step >= 2
            ? 'Packages my production Flutter app depends on: Dart, iOS and Android, direct and transitive.'
            : 'Can anyone guess what this number means?',
        subtitleMaxLines: 2,
      ),
    );
  }
}
