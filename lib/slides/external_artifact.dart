import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class ExternalArtifactSlide extends FlutterDeckSlideWidget {
  const ExternalArtifactSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/external-artifact',
          title: '21. External artifact problem',
          steps: 2,
          speakerNotes:
              '- The lockfile pins the Dart package, not the artifact the hook fetches.\n'
              '- [NEEDS VERIFICATION] integrity verification behavior for native asset downloads.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO(verify): standard integrity verification behavior for native asset downloads (docs/slides.md #21).
    return FlutterDeckSlide.split(
      leftBuilder: (context) => Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BigText('What I check for a downloaded artifact', fontSize: 38, accent: true, align: TextAlign.left),
            const SizedBox(height: 24),
            for (final q in const [
              'Is the URL versioned?',
              'Is it immutable?',
              'Is it redirected?',
              'Is a digest (SHA-256) verified?',
              'Is a signature verified?',
              'Is there provenance?',
              'Is the artifact executed?',
              'Is it bundled into the app as a runtime library?',
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(q, style: const TextStyle(fontSize: 30)),
              ),
          ],
        ),
      ),
      rightBuilder: (context) => Reveal(
        step: 2,
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ChainColumn(items: ['pubspec.lock', 'Dart package version / content'], fontSize: 28, nodeWidth: 620),
              SizedBox(height: 48),
              ChainColumn(
                items: ['Artifact fetched by the hook', 'A different trust boundary'],
                fontSize: 28,
                nodeWidth: 620,
                dangerIndexes: {1},
              ),
              SizedBox(height: 40),
              FooterLine('The lockfile does not necessarily pin the second one.', accent: true),
            ],
          ),
        ),
      ),
    );
  }
}
