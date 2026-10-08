import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Q&A grid: what do I need to know about a hook as a Dart program?
/// Answers are placeholders until verified against docs, SDK source and a PoC.
class ExecutionModelSlide extends FlutterDeckSlideWidget {
  const ExecutionModelSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/execution-model',
          title: '13. What can a hook do?',
          steps: 2,
          speakerNotes:
              '- A hook is a Dart program. Not unlimited arbitrary execution; there are constraints.\n'
              '- But calling native tools is legitimate, so it is a developer / CI execution surface.\n'
              '- [NEEDS VERIFICATION] Answers to be confirmed against official docs, SDK source and a PoC '
              'before the talk.',
        ),
      );

  // TODO: replace TBD answers with verified behavior (docs + SDK source + PoC).
  static const _rows = [
    (q: 'When does it fire?', a: 'TBD'),
    (q: 'Direct vs transitive?', a: 'TBD'),
    (q: 'Working directory?', a: 'TBD'),
    (q: 'Visible environment variables?', a: 'TBD'),
    (q: 'Filesystem access?', a: 'TBD'),
    (q: 'Network access?', a: 'TBD'),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Build hooks · execution model',
        headline: 'A hook is a Dart program.',
        pageNumber: '13',
        child: Padding(
          padding: const EdgeInsets.only(top: 72),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (i, row) in _rows.indexed)
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: DeckColors.rule)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Enter(
                          delayMs: 150 * i,
                          child: Text(
                            row.q,
                            style: fig(34, color: DeckColors.text),
                          ),
                        ),
                      ),
                      const SizedBox(width: 64),
                      Expanded(
                        flex: 11,
                        child: Enter(
                          step: 2,
                          delayMs: 250 * i,
                          dy: 0,
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 1,
                                color: DeckColors.accent,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  row.a,
                                  style: mono(26, color: DeckColors.accent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
