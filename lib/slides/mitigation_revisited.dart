import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class MitigationRevisitedSlide extends FlutterDeckSlideWidget {
  const MitigationRevisitedSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/mitigation-revisited',
          title: '31. Mitigation revisited',
          steps: 3,
          header: FlutterDeckHeaderConfiguration(title: 'Going deeper added two more attack paths'),
          speakerNotes:
              '- Same table as before. The deep dive and the native layer added two rows.\n'
              '- These rows only exist because we understood the mechanism.\n'
              '- [NEEDS VERIFICATION] the "Does not stop" column is a first draft.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO(verify): "Does not stop" column wording (docs/slides.md #31).
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Center(
          child: DeckTable(
            fontSize: 24,
            rowSteps: [1, 1, 1, 2, 3],
            accentRows: {3, 4},
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
              [
                'External artifact substitution',
                'Immutable versioned URLs, digest pinning, checksum / signature verification, provenance',
                'A malicious source that was signed correctly',
              ],
              [
                'Prebuilt binary risk',
                'Artifact inspection, checksum / signature, provenance, reproducible builds, trusted publisher',
                'A compromised upstream build',
              ],
            ],
          ),
        ),
      ),
    );
  }
}
