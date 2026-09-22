import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class DemoSlide extends FlutterDeckSlideWidget {
  const DemoSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/demo',
          title: '20. Demo',
          header: FlutterDeckHeaderConfiguration(title: 'Demo'),
          speakerNotes:
              '- Prefer prerecorded capture over live demo.\n'
              '- TODO: live or prerecorded is undecided.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: insert prerecorded terminal capture / screenshots (docs/slides.md #20).
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BigText('[TODO: prerecorded terminal capture / screenshots]', fontSize: 40, muted: true),
            const SizedBox(height: 48),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: const [
                Node('Find hook/build.dart in the pub cache', fontSize: 26),
                Node('Observe hook execution in the console', fontSize: 26),
                Node('Child process start', fontSize: 26),
                Node('Visible environment', fontSize: 26),
                Node('External artifact download', fontSize: 26),
                Node('URL / checksum validation in the source', fontSize: 26),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
