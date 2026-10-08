import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class AiSlide extends FlutterDeckSlideWidget {
  const AiSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/ai',
          title: '35. AI',
          steps: 2,
          speakerNotes:
              '- Do not ask AI "is this package safe."\n'
              '- AI reduced the cost of going one level deeper; verify every answer.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BigText(
              'Not a security decision maker. An investigation amplifier.',
              fontSize: 40,
              accent: true,
              align: TextAlign.left,
            ),
            const SizedBox(height: 32),
            for (final line in const [
              'Explain unfamiliar code',
              'Help read SDK source',
              'Trace call paths',
              'Narrow suspicious areas',
              'Build a minimal reproduction',
              'Design experiments',
              'List hypotheses',
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(line, style: const TextStyle(fontSize: 30)),
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
              BigText('Verify', fontSize: 44, accent: true),
              SizedBox(height: 32),
              ChainColumn(
                items: [
                  'AI answer',
                  'Official documentation',
                  'Source code',
                  'Experiment',
                  'Observation',
                ],
                fontSize: 26,
                gap: 2,
                nodeWidth: 520,
              ),
              SizedBox(height: 40),
              FooterLine(
                "The valuable part isn't the AI. It's the questions.",
                accent: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
