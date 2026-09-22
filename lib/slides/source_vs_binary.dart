import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class SourceVsBinarySlide extends FlutterDeckSlideWidget {
  const SourceVsBinarySlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/source-vs-binary',
          title: '28. Source vs binary',
          steps: 2,
          header: FlutterDeckHeaderConfiguration(title: 'Source distribution vs binary distribution'),
          speakerNotes:
              '- Source distribution: inspect and compile are close.\n'
              '- Binary distribution: another question remains.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            DeckTable(
              columns: ['Ecosystem / mechanism', 'Typical form', 'Build input'],
              fontSize: 24,
              rows: [
                ['Dart / pub', 'source package', 'source'],
                ['CocoaPods source_files', 'source', 'source'],
                ['SwiftPM .target', 'source', 'source'],
                ['Maven / Gradle JAR / AAR', 'precompiled', 'binary artifact'],
                ['CocoaPods vendored framework', 'precompiled', 'framework / XCFramework'],
                ['SwiftPM .binaryTarget', 'precompiled', 'binary artifact'],
                ['DevTools extension', 'precompiled web output', 'compiled extension artifact'],
              ],
            ),
            SizedBox(height: 20),
            Reveal(
              step: 2,
              child: BigText('Is this the source that produced the binary I actually consume?', fontSize: 40, accent: true),
            ),
          ],
        ),
      ),
    );
  }
}
