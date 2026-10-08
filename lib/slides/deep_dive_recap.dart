import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Recap of the build-hooks deep dive: three things the dive made visible
/// (execution, attack surfaces, auditing). Same item layout as Takeaways.
class DeepDiveRecapSlide extends FlutterDeckSlideWidget {
  const DeepDiveRecapSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/deep-dive-recap',
          title: '19. Deep dive recap',
          speakerNotes:
              '- Pause and collect. Digging into one mechanism made three things visible: how its '
              'code gets executed, which attack surfaces it opens, and how to audit it.\n'
              '- None of this was visible from the package page — it came from looking one level '
              'deeper.',
        ),
      );

  static const _items = [
    (
      title: 'How its code gets executed',
      detail: 'Part of a normal build — no opt-in, no prompt.',
    ),
    (
      title: 'Which attack surfaces it opens',
      detail: 'Network, child processes, the filesystem — and the artifact behind a URL.',
    ),
    (
      title: 'How to audit it',
      detail: 'Read the resolved source, re-check every version, chase what the build consumes.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Build hooks · recap',
        headline: 'What one deep dive made visible',
        pageNumber: '19',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, item) in _items.indexed)
                Enter(
                  delayMs: 500 * i,
                  child: Padding(
                    padding: EdgeInsets.only(top: i == 0 ? 0 : 64),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '0${i + 1}',
                          style: mono(50, color: DeckColors.accent),
                        ),
                        const SizedBox(width: 48),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: fig(48, height: 1.1)),
                              const SizedBox(height: 12),
                              Text(
                                item.detail,
                                style: fig(30, color: DeckColors.faint),
                              ),
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
