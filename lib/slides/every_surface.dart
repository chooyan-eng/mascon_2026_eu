import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Beyond build hooks: every other execution surface deserves the same
/// questions.
class EverySurfaceSlide extends FlutterDeckSlideWidget {
  const EverySurfaceSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/every-surface',
          title: '21. Same questions',
          speakerNotes:
              '- That was one surface. Every other one deserves the same treatment: understand the '
              'mechanism, understand the attack path, then choose the defense.\n'
              '- I read the docs, the SDK source and real packages, and built small experiments to say '
              'this much. Analyzer plugins, build_runner and DevTools extensions deserve the same.',
        ),
      );

  static const _mechanisms = [
    (label: 'Analyzer plugins', useMono: false),
    (label: 'build_runner / builders', useMono: true),
    (label: 'DevTools extensions', useMono: false),
  ];

  static const _questions = [
    'When does it run?',
    'Explicit opt-in?',
    'What does it fetch or run?',
    'What does the build consume?',
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Beyond build hooks',
        headline: 'Ask the same questions elsewhere',
        pageNumber: '21',
        child: Padding(
          padding: const EdgeInsets.only(top: 96),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (i, m) in _mechanisms.indexed)
                Enter(
                  delayMs: 300 * i,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: DeckColors.rule),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: Text(
                            m.label,
                            style: m.useMono
                                ? mono(40, color: DeckColors.text)
                                : fig(48, color: DeckColors.text),
                          ),
                        ),
                        Expanded(
                          flex: 14,
                          child: Wrap(
                            spacing: 14,
                            runSpacing: 14,
                            // 22px so the two long questions share a line;
                            // at 24px they wrap to 3 lines and the third
                            // mechanism row overflows the slide.
                            children: [
                              for (final q in _questions) Chip24(q, size: 22),
                            ],
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
