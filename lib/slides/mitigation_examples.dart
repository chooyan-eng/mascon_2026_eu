import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Placeholder: a few concrete mitigations, when they actually work, and
/// what they do not cover. Content TBD (docs/slides.md #23).
class MitigationExamplesSlide extends FlutterDeckSlideWidget {
  const MitigationExamplesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/mitigation-examples',
          title: '22. Mitigation examples',
          speakerNotes: '- Placeholder — content to be decided.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Mitigations',
        headline: 'Mitigation examples',
        pageNumber: '22',
        child: Center(
          child: Text('[TODO: mitigation examples]', style: fig(40, color: DeckColors.faintest)),
        ),
      ),
    );
  }
}
