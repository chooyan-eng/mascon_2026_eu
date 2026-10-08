import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class SourceIntegrityProvenanceSlide extends FlutterDeckSlideWidget {
  const SourceIntegrityProvenanceSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/source-integrity-provenance',
          title: '13. Source, integrity, provenance',
          steps: 2,
          header: FlutterDeckHeaderConfiguration(
            title: 'Three different questions',
          ),
          speakerNotes:
              '- Provenance tells you where the bytes came from, not whether the source is safe.\n'
              '- [NEEDS VERIFICATION] provenance / attestation support and how much to explain.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO(verify): provenance / attestation support (docs/slides.md #13).
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InfoCard(
                    title: 'Source review',
                    lines: ['Is this source behavior acceptable?'],
                    fontSize: 28,
                  ),
                ),
                SizedBox(width: 32),
                Expanded(
                  child: InfoCard(
                    title: 'Artifact integrity',
                    lines: ['Are these the exact bytes I expected?'],
                    fontSize: 28,
                  ),
                ),
                SizedBox(width: 32),
                Expanded(
                  child: InfoCard(
                    title: 'Build provenance',
                    lines: ['Where did these bytes come from?'],
                    fontSize: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 72),
            Reveal(
              step: 2,
              child: ChainRow(
                fontSize: 26,
                separator: const BigText('≠', fontSize: 40, accent: true),
                items: const [
                  'Version locking',
                  'Artifact verification',
                  'Publisher verification',
                  'Build provenance',
                  'Source-code security review',
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
