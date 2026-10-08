import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

class TitleSlide extends FlutterDeckSlideWidget {
  const TitleSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/title',
          title: '01. Title',
          speakerNotes: '- Hello everyone. My name is Tsuyoshi, and I came here from Japan.',
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
              Enter(
                child: Text(
                  'masCon / next.app devCon · Berlin 2026',
                  style: mono(
                    24,
                    color: DeckColors.accent,
                    letterSpacing: 24 * 0.08,
                  ),
                ),
              ),
              const SizedBox(height: 56),
              Enter(
                delayMs: 150,
                child: Text(
                  'Security Risks of Packages\nin Mobile App Development',
                  style: fig(91, height: 1.02, letterSpacing: -0.03 * 91),
                ),
              ),
              const SizedBox(height: 56),
              const GrowLine(delayMs: 700),
              const SizedBox(height: 56),
              Enter(
                delayMs: 900,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('Tsuyoshi Chujo', style: fig(52)),
                    const SizedBox(width: 40),
                    Text(
                      'Flutter developer · package author',
                      style: fig(28, color: DeckColors.faint),
                    ),
                    const SizedBox(width: 40),
                    Text(
                      kSocialHandle,
                      style: mono(26, color: DeckColors.accent),
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
