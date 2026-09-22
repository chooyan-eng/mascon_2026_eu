import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class AttackPathASlide extends FlutterDeckSlideWidget {
  const AttackPathASlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/attack-path-a',
          title: '08. Attack path A',
          steps: 5,
          header: FlutterDeckHeaderConfiguration(title: 'Attack path A: a malicious package release'),
          speakerNotes:
              '- Generalize the incident we just saw. This is the typical story.\n'
              '- The important part is where it goes from here.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const SlideBody(
        child: Center(
          child: ChainColumn(
            stepped: true,
            nodeWidth: 900,
            dangerIndexes: {1, 2, 4},
            items: [
              'Legitimate dependency',
              'Maintainer / account / release process compromised',
              'Malicious version published',
              'Dependency resolution / update',
              'Malicious code reaches your environment',
            ],
          ),
        ),
      ),
    );
  }
}
