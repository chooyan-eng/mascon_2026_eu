import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class TakeawaysSlide extends FlutterDeckSlideWidget {
  const TakeawaysSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/takeaways',
          title: '36. Takeaways',
          steps: 3,
          speakerNotes: "- Don't start with the mitigation. Start by understanding how the system works.",
        ),
      );

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Understand your platform', "If you don't know the mechanism, you don't know what you trust."),
      ('Understand the attack path', 'Where it enters, where it executes, who is affected.'),
      ('Choose mitigations based on that understanding', 'Pick the control that stops a concrete attack path.'),
    ];
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (i, (title, body)) in items.indexed)
              Reveal(
                step: i + 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(fontSize: 88, fontWeight: FontWeight.w800, color: DeckColors.accent, height: 1),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w700, height: 1.2)),
                            const SizedBox(height: 8),
                            Text(body, style: const TextStyle(fontSize: 30, color: DeckColors.muted, height: 1.3)),
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
    );
  }
}
