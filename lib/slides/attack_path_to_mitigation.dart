import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class AttackPathToMitigationSlide extends FlutterDeckSlideWidget {
  const AttackPathToMitigationSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/attack-path-to-mitigation',
          title: '14. Attack path → mitigation',
          steps: 3,
          header: FlutterDeckHeaderConfiguration(title: 'Which attack path does this mitigation actually stop?'),
          speakerNotes:
              '- Not a checklist. Each control maps to an attack path and has something it does not stop.\n'
              '- Overview level only; two more rows appear after the deep dive (slide 31).\n'
              '- [NEEDS VERIFICATION] the "Does not stop" column is a first draft from outline 36-37.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO(verify): "Does not stop" column wording (docs/slides.md #14).
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Center(
          child: DeckTable(
            stepped: true,
            fontSize: 24,
            columns: ['Attack path', 'Mitigation', 'Does not stop'],
            columnWidths: {0: FlexColumnWidth(1.1), 1: FlexColumnWidth(1.6), 2: FlexColumnWidth(1.6)},
            rows: [
              [
                'Unexpected package update',
                'Lockfile, controlled updates, dependency diff review',
                'A locked version that is itself malicious',
              ],
              [
                'CI code execution',
                'Least privilege, minimal secrets, reduced token permissions, isolated workflows',
                'Code that still runs inside the allowed boundary',
              ],
              [
                'Developer machine execution',
                'Disposable environment, container / VM, credential and filesystem separation',
                'Everything inside the sandbox boundary',
              ],
            ],
          ),
        ),
      ),
    );
  }
}
