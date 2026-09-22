import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class ExistingTrustedPathSlide extends FlutterDeckSlideWidget {
  const ExistingTrustedPathSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/existing-trusted-path',
          title: '23. Existing trusted path',
          speakerNotes:
              '- hook + curl + Process.run added in a new version stands out.\n'
              '- If hook -> download -> run already exists, the diff can be zero.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.quote(
      quote: 'The hardest malicious update may not add a new capability. It may abuse a capability you already trusted.',
      attribution: "Don't only look for new execution paths. Look at what changed behind existing trusted paths.",
      quoteMaxLines: 4,
    );
  }
}
