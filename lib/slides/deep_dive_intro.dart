import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Divider: from here on, everything is build hooks.
class DeepDiveIntroSlide extends FlutterDeckSlideWidget {
  const DeepDiveIntroSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/deep-dive-intro',
          title: '11. Divider: Build hooks',
          speakerNotes:
              '- Not broad coverage: pick one mechanism — build hooks — dig deep, and share what I '
              'learned on the way.\n'
              '- Ask the audience to keep one thing in mind: the process of digging deeper is '
              'transferable to any mechanism, in any ecosystem — not a talk just for Flutter '
              'developers.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        pageNumber: '11',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Enter(child: Text('Build hooks', style: fig(112, height: 1))),
            const SizedBox(height: 32),
            Enter(
              delayMs: 350,
              child: Text(
                'deep dive',
                style: fig(45, color: DeckColors.faint, italic: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
