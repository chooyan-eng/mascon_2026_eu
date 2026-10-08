import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Takeaways merged with the community proposal: pick one thing, go one
/// level deeper, share what you learn — closed by the gold one-liner that
/// the thank-you slide echoes.
class TakeawaysSlide extends FlutterDeckSlideWidget {
  const TakeawaysSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/takeaways',
          title: '28. Takeaways',
          speakerNotes:
              '- We went deep today; no developer can investigate every dependency this deeply, '
              "and we don't all need to become security specialists.\n"
              '- Pick one mechanism you are curious about, go one level deeper — like we did with '
              'build hooks — and share what you learn: a post, a talk, an issue, a tool.\n'
              '- Together we raise the defense of the whole community. Close with: '
              "Let's dig deeper together.",
        ),
      );

  static const _items = [
    (
      title: 'Pick one thing',
      detail: 'One mechanism you are curious about — in any ecosystem.',
    ),
    (
      title: 'Go one level deeper',
      detail: 'Understand how it works and where the attack path is.',
    ),
    (
      title: 'Share what you learn',
      detail: 'A post, a talk, an issue, a tool — the whole community gets stronger.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        padded: false,
        pageNumber: '28',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, item) in _items.indexed)
                Enter(
                  delayMs: 500 * i,
                  child: Padding(
                    padding: EdgeInsets.only(top: i == 0 ? 0 : 72),
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
              Enter(
                delayMs: 1700,
                child: Padding(
                  padding: const EdgeInsets.only(top: 96),
                  child: Text(
                    "Let's dig deeper together.",
                    style: fig(40, color: DeckColors.accent, italic: true),
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
