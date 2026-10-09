import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

class ThankYouSlide extends FlutterDeckSlideWidget {
  const ThankYouSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/thank-you',
          title: '30. Thank you',
          speakerNotes: '- Q&A if the event format has it.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        padded: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 160),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Enter(child: Text('Thank you.', style: fig(112, height: 1))),
              const SizedBox(height: 56),
              const GrowLine(delayMs: 500),
              const SizedBox(height: 56),
              Enter(
                delayMs: 700,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('Tsuyoshi Chujo', style: fig(48)),
                    const SizedBox(width: 40),
                    Text(
                      kSocialHandle,
                      style: mono(26, color: DeckColors.accent),
                    ),
                    const Spacer(),
                    Text(
                      "Let's dig deeper together.",
                      style: fig(36, color: DeckColors.faint, italic: true),
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
