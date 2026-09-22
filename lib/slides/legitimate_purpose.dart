import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class LegitimatePurposeSlide extends FlutterDeckSlideWidget {
  const LegitimatePurposeSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/legitimate-purpose',
          title: '17. Legitimate purpose',
          header: FlutterDeckHeaderConfiguration(title: 'Build hooks exist for good reasons'),
          speakerNotes:
              '- Do not start from "build hooks are dangerous."\n'
              '- This matters later for detection.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        footerLine: 'Download and process execution are not, by themselves, suspicious in a build hook.',
        footerAccent: true,
        child: Center(
          child: Bullets(const [
            'Native code compilation',
            'Native asset preparation',
            'Prebuilt native asset download',
            'Linking information preparation',
            'Platform-specific build integration',
          ]),
        ),
      ),
    );
  }
}
