import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// In the Dart ecosystem the exact package code your build runs is readable:
/// resolved packages sit in the pub cache, and `dart pub unpack` fetches any
/// version that is not cached.
class InspectPackagesSlide extends FlutterDeckSlideWidget {
  const InspectPackagesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/inspect-packages',
          title: '18. Inspect the packages',
          steps: 2,
          speakerNotes:
              "- In Flutter's case you can read everything: hosted packages your build resolved "
              'are already in the pub cache.\n'
              '- If a version is not in your cache, dart pub unpack fetches it into a local directory.\n'
              '- So the exact set of packages that will run is always available to read. '
              'The artifact a hook fetches is the exception we saw earlier.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Inspect',
        headline: 'Get the exact packages your build runs',
        pageNumber: '18',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Enter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('~/.pub-cache', style: mono(40, color: DeckColors.text)),
                          const SizedBox(height: 20),
                          Text(
                            'Hosted packages your build resolved are already on disk',
                            style: fig(28, color: DeckColors.faint, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(color: DeckColors.line, width: 80, thickness: 1),
                  Expanded(
                    child: Enter(
                      delayMs: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('dart pub unpack', style: mono(40, color: DeckColors.text)),
                          const SizedBox(height: 20),
                          Text(
                            'Fetches any package version into a local directory for inspection',
                            style: fig(28, color: DeckColors.faint, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          Text(r'$ dart pub unpack some_package', style: mono(24, color: DeckColors.faintest)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 110),
            Enter(
              step: 2,
              child: Text(
                'The exact set of packages that will run is always available to read.',
                textAlign: TextAlign.center,
                style: fig(45, color: DeckColors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
