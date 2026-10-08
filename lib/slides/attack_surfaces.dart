import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/deck_widgets.dart';

class AttackSurfacesSlide extends FlutterDeckSlideWidget {
  const AttackSurfacesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/attack-surfaces',
          title: '11. Attack surfaces',
          header: FlutterDeckHeaderConfiguration(
            title: 'One Dart package, many attack surfaces',
          ),
          speakerNotes:
              '- Transition: the story so far applies to almost any ecosystem; here, take Flutter / Dart packages as the example and see how it looks there.\n'
              '- Even a single Dart package has several places where its code can run.\n'
              '- Runtime code ends up on the end-user device; the others run on my machine or CI.\n'
              '- No ranking, and no surface is singled out yet.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Library code', 'runs inside the app'),
      ('Build hooks / link hooks', 'run during the build'),
      ('Analyzer plugins', 'run inside the analysis server'),
      ('build_runner / builders', 'run during code generation'),
      ('DevTools extensions', 'run inside DevTools'),
    ];
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        footerLine: 'Same language, same package. Not the same attack surface.',
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (name, where) in items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 640,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 40,
                            color: DeckColors.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Tag(where),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
