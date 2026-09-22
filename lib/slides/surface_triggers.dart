import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class SurfaceTriggersSlide extends FlutterDeckSlideWidget {
  const SurfaceTriggersSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/surface-triggers',
          title: '12. Surface triggers',
          header: FlutterDeckHeaderConfiguration(title: 'Each surface has its own trigger and its own opt-in'),
          speakerNotes:
              '- Overview only. What matters: when does it run, and did I opt in?\n'
              '- [NEEDS VERIFICATION] trigger / opt-in descriptions for each mechanism.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO(verify): confirm trigger / opt-in descriptions (docs/slides.md #12).
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InfoCard(
                title: 'Hooks',
                fontSize: 24,
                lines: [
                  'hook/build.dart, hook/link.dart',
                  'Part of the normal build',
                  'Prepare native assets',
                ],
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: InfoCard(
                title: 'Analyzer plugins',
                fontSize: 24,
                lines: [
                  'Runs inside the analysis server / IDE',
                  'Not auto-run just because a dependency exists',
                  'Explicit configuration',
                  'Can run continuously',
                ],
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: InfoCard(
                title: 'build_runner',
                fontSize: 24,
                lines: [
                  'Builders are Dart code',
                  'Runs when the project runs build_runner',
                  'Code generation is the normal use',
                ],
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: InfoCard(
                title: 'DevTools extensions',
                fontSize: 24,
                lines: [
                  'Shipped inside a package',
                  'User enables it (trust boundary)',
                  'Precompiled Flutter Web output',
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
