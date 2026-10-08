import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Every control has a boundary. Knowing the boundary is the point.
class NoMagicSlide extends FlutterDeckSlideWidget {
  const NoMagicSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/no-magic',
          title: '26. No single checkbox',
          speakerNotes:
              '- There is no single "supply chain protection enabled" checkbox.\n'
              '- Every tool has a boundary. Knowing the boundary is the point.',
        ),
      );

  static const _rows = [
    (
      control: 'Lockfile',
      covers: 'unexpected updates',
      not: 'malicious locked content',
    ),
    (
      control: 'Pub content hash',
      covers: 'the package archive',
      not: 'what the hook fetches later',
    ),
    (
      control: 'Source review',
      covers: 'source behavior',
      not: 'every dependency, every time',
    ),
    (
      control: 'Scanners',
      covers: 'known bad patterns',
      not: 'malicious logic, reliably',
    ),
    (
      control: 'Sandboxes',
      covers: 'what crosses the boundary',
      not: 'everything inside the boundary',
    ),
    (
      control: 'Provenance',
      covers: 'where the bytes came from',
      not: 'safety of the source',
    ),
    (
      control: 'Binary analysis',
      covers: 'the artifact itself',
      not: 'costs — far more than source review',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Mitigations',
        headline: 'No single “supply chain protection” checkbox',
        pageNumber: '26',
        child: Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: DeckColors.line)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    SizedBox(
                      width: 420,
                      child: Text(
                        'CONTROL',
                        style: fig(
                          24,
                          color: DeckColors.faintest,
                          letterSpacing: 24 * 0.08,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'COVERS',
                        style: fig(
                          24,
                          color: DeckColors.faintest,
                          letterSpacing: 24 * 0.08,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'DOES NOT COVER',
                        style: fig(
                          24,
                          color: DeckColors.accent,
                          letterSpacing: 24 * 0.08,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              for (final (i, row) in _rows.indexed)
                Enter(
                  delayMs: 120 * i,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: DeckColors.rule),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 420,
                          child: Text(
                            row.control,
                            style: fig(32, color: DeckColors.text),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            row.covers,
                            style: fig(28, color: DeckColors.faint),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            row.not,
                            style: fig(28, color: DeckColors.accent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
