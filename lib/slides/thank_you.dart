import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class ThankYouSlide extends FlutterDeckSlideWidget {
  const ThankYouSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/thank-you',
          title: '38. Thank you',
          speakerNotes: '- Q&A if the event format has it.',
          footer: FlutterDeckFooterConfiguration(showFooter: false),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.title(title: 'Thank you!', subtitle: 'Tsuyoshi Chujo · @chooyan_i18n',
      speakerInfoBuilder: (context) => const SizedBox.shrink(),
    );
  }
}
