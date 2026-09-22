import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/speaker_info.dart';

class TitleSlide extends FlutterDeckSlideWidget {
  const TitleSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/title',
          title: '01. Title',
          speakerNotes: '- Hello everyone. My name is Tsuyoshi, and I came here from Japan.',
          footer: FlutterDeckFooterConfiguration(showFooter: false),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.title(
      title: 'Security Risks of Packages in Mobile App Development',
      subtitle: 'masCon / next.app devCon Berlin 2026',
      speakerInfoBuilder: (context) => const SpeakerInfoBlock(),
    );
  }
}
