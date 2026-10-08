import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// The artifact a hook fetches lives in a different trust boundary than the
/// pub package itself.
class ExternalArtifactSlide extends FlutterDeckSlideWidget {
  const ExternalArtifactSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/external-artifact',
          title: '16. Trust boundary',
          steps: 2,
          speakerNotes:
              '- The lockfile pins the Dart package, not the artifact the hook fetches.\n'
              '- Everything after the external URL is a different trust boundary.\n'
              '- For a downloaded artifact I check: versioned URL, immutable, no redirect, SHA-256 digest, '
              'signature, provenance, is it executed, is it bundled into the app.',
        ),
      );

  static const _nodes = [
    (label: 'pub package', gold: false),
    (label: 'hook/build.dart', gold: false),
    (label: 'external URL', gold: true),
    (label: 'artifact', gold: true),
    (label: 'run · bundle', gold: true),
  ];

  static const _checks = [
    'versioned URL',
    'immutable',
    'no redirect',
    'SHA-256 digest',
    'signature',
    'provenance',
    'executed?',
    'bundled into the app?',
  ];

  @override
  Widget build(BuildContext context) {
    // Keep the 5-node chain comfortably inside the 1680px content width.
    const nodeW = 276.0, gap = 56.0;
    const bracketW = 3 * nodeW + 2 * gap;
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Build hooks · trust boundary',
        headline: 'Same version. Same bytes?',
        pageNumber: '16',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (final (i, node) in _nodes.indexed) ...[
                  if (i > 0)
                    SizedBox(
                      width: gap,
                      child: GrowLine(
                        delayMs: 350 * i - 150,
                        durationMs: 350,
                        color: node.gold && _nodes[i - 1].gold
                            ? DeckColors.accent
                            : DeckColors.line,
                      ),
                    ),
                  Enter(
                    delayMs: 350 * i,
                    child: OutlineBox(
                      node.label,
                      width: nodeW,
                      height: 110,
                      fontSize: 26,
                      useMono: true,
                      borderColor: node.gold
                          ? DeckColors.accent
                          : DeckColors.line,
                      textColor: node.gold
                          ? DeckColors.accent
                          : DeckColors.faint,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 2 * (nodeW + gap) + bracketW,
              height: 120,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Enter(
                      step: 2,
                      dy: -12,
                      child: const _Bracket(
                        width: bracketW,
                        label: 'pubspec.lock',
                        gold: false,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 2 * (nodeW + gap),
                    top: 52,
                    child: Enter(
                      step: 2,
                      delayMs: 300,
                      dy: -12,
                      child: const _Bracket(
                        width: bracketW,
                        label: 'a different trust boundary',
                        gold: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 56),
            Enter(
              step: 2,
              delayMs: 900,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('check', style: mono(24, color: DeckColors.accent)),
                  const SizedBox(width: 28),
                  Expanded(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [for (final check in _checks) Chip24(check)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bracket extends StatelessWidget {
  const _Bracket({
    required this.width,
    required this.label,
    required this.gold,
  });

  final double width;
  final String label;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final color = gold ? DeckColors.accent : DeckColors.line;
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Container(
            height: 18,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: color, width: gold ? 2 : 1),
                right: BorderSide(color: color, width: gold ? 2 : 1),
                bottom: BorderSide(color: color, width: gold ? 2 : 1),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: gold
                ? fig(30, color: DeckColors.accent)
                : mono(24, color: DeckColors.faintest),
          ),
        ],
      ),
    );
  }
}
