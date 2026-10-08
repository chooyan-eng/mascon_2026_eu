import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class FollowOneHookSlide extends FlutterDeckSlideWidget {
  const FollowOneHookSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/follow-one-hook',
          title: '19. Follow one hook',
          steps: 8,
          header: FlutterDeckHeaderConfiguration(
            title: 'Follow one hook all the way down',
          ),
          speakerNotes:
              '- Center of the talk. Show how I investigated, not only the result.\n'
              '- TODO: decide which package to follow and what was observed.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: decide the actual package followed and observed results (docs/slides.md #19).
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Center(
          child: ChainColumn(
            stepped: true,
            fontSize: 26,
            gap: 2,
            nodeWidth: 900,
            accentIndexes: {3, 4, 6},
            items: [
              'Package',
              'hook/build.dart',
              'imports / API calls',
              'Process execution?',
              'Network download?',
              'Downloaded artifact',
              'Checksum / signature verification?',
              'Executable / library / generated output — where does it go next?',
            ],
          ),
        ),
      ),
    );
  }
}
