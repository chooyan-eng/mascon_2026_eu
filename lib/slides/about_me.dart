import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class AboutMeSlide extends FlutterDeckSlideWidget {
  const AboutMeSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/about-me',
          title: '02. About me',
          steps: 2,
          header: FlutterDeckHeaderConfiguration(title: 'About me'),
          speakerNotes:
              '- Quick self introduction with the bullets.\n'
              '- Then: I listed a few things, but what it means is this. I am not a security expert.\n'
              '- I take part in the Flutter ecosystem every day, as a package user and as a package author.\n'
              '- Today I talk from that viewpoint.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Bullets(const [
              'Flutter developer from Japan',
              'I build and publish mobile applications',
              'I develop and maintain Dart / Flutter packages',
              'Recently digging into software supply chain security',
            ]),
            const SizedBox(height: 40),
            Reveal(
              step: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
                decoration: BoxDecoration(
                  color: DeckColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: DeckColors.accent, width: 2),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText('Not a security expert.', fontSize: 48, accent: true, align: TextAlign.left),
                    SizedBox(height: 12),
                    BigText(
                      'Someone who lives in the Flutter ecosystem every day, '
                      'as a package user and as a package author.',
                      fontSize: 36,
                      align: TextAlign.left,
                    ),
                    SizedBox(height: 12),
                    BigText('That is the viewpoint of this talk.', fontSize: 36, muted: true, align: TextAlign.left),
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
