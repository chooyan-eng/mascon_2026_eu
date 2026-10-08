import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Mitigation example 01: cooldown — adopt new versions only after they have
/// been public for a while.
class MitigationCooldownSlide extends FlutterDeckSlideWidget {
  const MitigationCooldownSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/mitigation-cooldown',
          title: '24. Mitigation: cooldown',
          steps: 2,
          speakerNotes:
              '- Good news: there are things you can do without knowing every low-level detail — '
              'two concrete mitigations, both easy to adopt.\n'
              '- First example: cooldown. Adopt a new version only after it has been public for a '
              'while; Dependabot and Renovate support this natively.\n'
              '- Many compromised releases are detected and pulled within days — remember, '
              'universal_file_viewer was retracted. A cooldown skips exactly that window.\n'
              '- It does not cover malware that stays unnoticed longer, and it does not protect '
              'whoever updates first.\n'
              '- Trade-off: legitimate fixes, including security patches, also arrive late.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Mitigations · example 01',
        headline: 'Cooldown — wait before you update',
        pageNumber: '24',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Enter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adopt a new version only after it has been public for a while.',
                    style: fig(40, color: DeckColors.sub),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'e.g. Dependabot cooldown · Renovate minimumReleaseAge',
                    style: mono(24, color: DeckColors.faintest),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 72),
            const _Row(
              label: 'COVERS',
              text: 'Many compromised releases are detected and pulled within days — '
                  'a cooldown skips exactly that window',
              step: 1,
              delayMs: 300,
            ),
            const _Row(
              label: 'DOES NOT COVER',
              text: 'Malware that stays unnoticed longer than your cooldown — '
                  'and it does not protect whoever updates first',
              gold: true,
              step: 2,
            ),
            const _Row(
              label: 'TRADE-OFF',
              text: 'Legitimate fixes, including security patches, also arrive late',
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
        decoration: BoxDecoration(border: Border(top: BorderSide(color: DeckColors.rule))),
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
