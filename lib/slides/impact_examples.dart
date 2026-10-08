import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Two kinds of victims: developers / CI (concrete examples) and end users
/// (too varied to enumerate — kept deliberately vague).
class ImpactExamplesSlide extends FlutterDeckSlideWidget {
  const ImpactExamplesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/impact-examples',
          title: '06. Impact examples',
          steps: 2,
          speakerNotes:
              '- Two kinds of victims.\n'
              '- Developer / CI side: credential theft, private source code leaks, and malicious '
              'versions published with the stolen credentials — the chain continues.\n'
              '- End-user side: the damage is too varied to enumerate. Malicious code ships inside '
              'the app, so it is anything the app can do on the device.\n'
              '- Both belong in our threat model.\n'
              "- Now let's look at what a real compromise looks like.",
        ),
      );

  static const _devImpacts = [
    'Credential theft',
    'Private source code leaks',
    'Malicious versions published with stolen credentials',
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Supply chain',
        headline: 'Impact examples',
        pageNumber: '06',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 96),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Enter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DEVELOPERS / CI', style: mono(24, color: DeckColors.accent, letterSpacing: 24 * 0.08)),
                        const SizedBox(height: 40),
                        for (final impact in _devImpacts)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 28),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: DeckColors.accent),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(child: Text(impact, style: fig(36, height: 1.25))),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(color: DeckColors.line, width: 96, thickness: 1),
                Expanded(
                  child: Enter(
                    step: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('END USERS', style: mono(24, color: DeckColors.accent, letterSpacing: 24 * 0.08)),
                        const SizedBox(height: 40),
                        Text('Malicious code ships inside the app.', style: fig(36, height: 1.25)),
                        const SizedBox(height: 20),
                        Text(
                          'The damage is anything the app can do on the device — too varied to enumerate.',
                          style: fig(28, color: DeckColors.faint, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
