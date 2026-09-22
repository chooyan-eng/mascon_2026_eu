import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class RealIncidentSlide extends FlutterDeckSlideWidget {
  const RealIncidentSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/real-incident',
          title: '07. Real-world incident',
          header: FlutterDeckHeaderConfiguration(title: 'This is not hypothetical'),
          speakerNotes:
              '- Show one or two incidents briefly. Goal is to show it really happens, not to tell the story.\n'
              '- TODO: pick the incidents (npm / PyPI, clear attack path).',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: replace with 1-2 real package compromise incidents (see docs/slides.md #09).
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Center(child: BigText('[TODO: 1–2 real package compromise incidents]', fontSize: 44, muted: true)),
      ),
    );
  }
}
