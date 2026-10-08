import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Divider: the deep dive is over — widen the view again.
class ZoomOutSlide extends FlutterDeckSlideWidget {
  const ZoomOutSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/zoom-out',
          title: '20. Divider: Zoom out',
          speakerNotes:
              '- From here, widen the view again: the same questions apply to the other surfaces, '
              'and beyond Dart.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        pageNumber: '20',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Enter(child: Text('Beyond build hooks', style: fig(112, height: 1))),
            const SizedBox(height: 32),
            Enter(
              delayMs: 350,
              child: Text(
                'widen the view',
                style: fig(45, color: DeckColors.faint, italic: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
