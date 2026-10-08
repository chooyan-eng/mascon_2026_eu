import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

class AboutMeSlide extends FlutterDeckSlideWidget {
  const AboutMeSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/about-me',
          title: '02. About me',
          steps: 3,
          speakerNotes:
              '- Quick self introduction: package user, package author.\n'
              '- Then, with the strikethrough: I am not a security expert.\n'
              '- I take part in the Flutter ecosystem every day, as a package user and as a package author.\n'
              '- Today I talk from that viewpoint.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'About me',
        pageNumber: '02',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Enter(
              child: Row(
                children: [
                  Container(
                    width: 168,
                    height: 168,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: DeckColors.accent),
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/me_photo.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tsuyoshi Chujo', style: fig(56, height: 1)),
                      const SizedBox(height: 8),
                      Text(
                        'Flutter developer from Japan',
                        style: fig(32, color: DeckColors.faint),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 88),
            Enter(
              delayMs: 350,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Package user',
                            style: fig(
                              67,
                              height: 1,
                              letterSpacing: -0.02 * 67,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Cardcraft, and more',
                            style: fig(30, color: DeckColors.faint),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      color: DeckColors.line,
                      width: 80,
                      thickness: 1,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Package author',
                            style: fig(
                              67,
                              height: 1,
                              letterSpacing: -0.02 * 67,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              style: fig(30, color: DeckColors.faint),
                              children: [
                                TextSpan(
                                  text: 'crop_your_image',
                                  style: mono(28, color: DeckColors.faint),
                                ),
                                const TextSpan(text: ', '),
                                TextSpan(
                                  text: 'animated_to',
                                  style: mono(28, color: DeckColors.faint),
                                ),
                                const TextSpan(text: ', and more'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 88),
            Enter(
              step: 2,
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Text(
                        'Security expert',
                        style: fig(
                          84,
                          color: DeckColors.faintest,
                          italic: true,
                          height: 1.1,
                        ),
                      ),
                      Positioned(
                        left: -12,
                        right: -12,
                        top: 84 * 1.1 * 0.56,
                        child: const GrowLine(
                          step: 3,
                          thickness: 4,
                          durationMs: 700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
