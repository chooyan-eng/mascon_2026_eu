import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Mitigation example 02: respect the lockfile — resolve exactly what
/// pubspec.lock records, in CI too.
class MitigationLockfileSlide extends FlutterDeckSlideWidget {
  const MitigationLockfileSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/mitigation-lockfile',
          title: '25. Mitigation: lockfile',
          steps: 2,
          speakerNotes:
              '- Second example: respect the lockfile, in CI too — dart pub get --enforce-lockfile.\n'
              '- No unintended version enters the build; every update becomes an explicit, '
              'reviewable diff.\n'
              '- It does not cover a locked version that is already malicious, or what the lockfile '
              'does not pin — like the artifact a hook downloads, the boundary we saw earlier.\n'
              '- Trade-off: updates need deliberate maintenance; falling behind accumulates '
              'unpatched issues.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Mitigations · example 02',
        headline: 'Respect the lockfile',
        pageNumber: '25',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Enter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Build from exactly what pubspec.lock records — in CI too.',
                    style: fig(40, color: DeckColors.sub),
                  ),
                  const SizedBox(height: 16),
                  Text(r'$ dart pub get --enforce-lockfile', style: mono(24, color: DeckColors.faintest)),
                ],
              ),
            ),
            const SizedBox(height: 72),
            const _Row(
              label: 'COVERS',
              text: 'No unintended version enters the build — every update becomes '
                  'an explicit, reviewable diff',
              step: 1,
              delayMs: 300,
            ),
            const _Row(
              label: 'DOES NOT COVER',
              text: 'A locked version that is already malicious — and what the lockfile '
                  'does not pin, like the artifact a hook downloads',
              gold: true,
              step: 2,
            ),
            const _Row(
              label: 'TRADE-OFF',
              text: 'Updates need deliberate maintenance — falling behind accumulates '
                  'unpatched issues',
              step: 2,
              delayMs: 300,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.text, required this.step, this.delayMs = 0, this.gold = false});

  final String label;
  final String text;
  final int step;
  final int delayMs;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return Enter(
      step: step,
      delayMs: delayMs,
      child: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: DeckColors.rule))),
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            SizedBox(
              width: 380,
              child: Text(
                label,
                style: mono(24, color: gold ? DeckColors.accent : DeckColors.faintest, letterSpacing: 24 * 0.08),
              ),
            ),
            Expanded(
              child: Text(text, style: fig(32, color: gold ? DeckColors.accent : DeckColors.text, height: 1.35)),
            ),
          ],
        ),
      ),
    );
  }
}
