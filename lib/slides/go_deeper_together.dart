import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Closing proposal: none of us can watch the whole supply chain alone —
/// pick one thing, go one level deeper, share what you learn.
class GoDeeperTogetherSlide extends FlutterDeckSlideWidget {
  const GoDeeperTogetherSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/go-deeper-together',
          title: '28. Go deeper together',
          // Step 1 is intentionally blank: the community message is spoken
          // over an empty slide before the three lines appear.
          steps: 4,
          speakerNotes:
              '- We went quite deep today. No developer can investigate every dependency and every '
              'mechanism this deeply, and it is not realistic for all of us to become security '
              'specialists.\n'
              '- But every one of us can pick one mechanism and look one level deeper than usual — '
              'like I did with build hooks — and share what we learned: a post, a talk, an issue, '
              'a tool.\n'
              '- None of us can watch the whole supply chain alone; together we raise the defense '
              'of the entire community.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        pageNumber: '28',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Enter(step: 2, child: Text('Pick one thing.', style: fig(64, height: 1.2))),
            const SizedBox(height: 32),
            Enter(step: 3, child: Text('Go one level deeper.', style: fig(64, height: 1.2))),
            const SizedBox(height: 32),
            Enter(step: 4, child: Text('Share what you learn.', style: fig(64, height: 1.2))),
            const SizedBox(height: 88),
            Enter(
              step: 4,
              delayMs: 900,
              child: Text(
                "Let's dig deeper together.",
                style: fig(40, color: DeckColors.accent, italic: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
