import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

class ExistsVsExecutesSlide extends FlutterDeckSlideWidget {
  const ExistsVsExecutesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/exists-vs-executes',
          title: '09. Exists ≠ executes',
          steps: 2,
          speakerNotes:
              '- Even when malicious code gets onto the disk, it does not automatically run. '
              'A compromised package can sit in my pub cache and do nothing: code that exists is one '
              'thing; code that executes is another — that difference is exactly where the defense lives.\n'
              '- Attackers did not run arbitrary code in some incomprehensible way: in the incidents, '
              'they abused an execution mechanism the ecosystem itself provides — a lifecycle script, '
              'a build file, package code. So knowing those mechanisms is where the defense starts.\n'
              '- So the key question is: when can a package actually execute code?',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        pageNumber: '09',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Enter(
              child: Text(
                'MALICIOUS CODE',
                style: fig(
                  24,
                  color: DeckColors.faintest,
                  letterSpacing: 24 * 0.2,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Enter(
                  child: Text(
                    'exists',
                    style: fig(154, color: DeckColors.sub, height: 1),
                  ),
                ),
                const SizedBox(width: 64),
                Enter(
                  delayMs: 700,
                  child: Text(
                    '≠',
                    style: fig(154, color: DeckColors.accent, height: 1),
                  ),
                ),
                const SizedBox(width: 64),
                Enter(
                  delayMs: 900,
                  child: Text(
                    'executes',
                    style: fig(
                      154,
                      color: DeckColors.accent,
                      italic: true,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 96),
            Enter(
              step: 2,
              child: Text(
                'When can a package actually execute code?',
                style: fig(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
