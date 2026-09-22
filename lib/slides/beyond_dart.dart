import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class BeyondDartSlide extends FlutterDeckSlideWidget {
  const BeyondDartSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/beyond-dart',
          title: '26. Beyond Dart',
          steps: 5,
          header: FlutterDeckHeaderConfiguration(title: 'And that was only Dart'),
          speakerNotes:
              '- All of that was Dart / Flutter packages only.\n'
              '- A Flutter app also pulls in iOS and Android native libraries, and the same thinking applies there.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Center(
          child: ChainColumn(
            stepped: true,
            nodeWidth: 800,
            accentIndexes: {4},
            items: [
              'Flutter application',
              'Dart package',
              'Flutter plugin',
              'Android / iOS dependency',
              'Native artifact / source',
            ],
          ),
        ),
      ),
    );
  }
}
