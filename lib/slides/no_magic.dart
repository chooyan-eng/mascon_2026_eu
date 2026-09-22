import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class NoMagicSlide extends FlutterDeckSlideWidget {
  const NoMagicSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/no-magic',
          title: '32. No magic solution',
          header: FlutterDeckHeaderConfiguration(
            title: 'There is no single "supply chain protection enabled" checkbox.',
          ),
          speakerNotes: '- Every tool has a boundary. Knowing the boundary is the point.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Center(
          child: Bullets(const [
            'A lockfile limits unexpected updates, not malicious locked content',
            'A pub content hash protects the archive, not what the hook fetches later',
            'Source review works, but not for every dependency every time',
            'Scanners help, but do not reliably catch malicious logic',
            'Sandboxes have boundaries',
            'Provenance shows origin, not safety of the source',
            'Binary analysis is possible, but costs more than source review',
          ]),
        ),
      ),
    );
  }
}
