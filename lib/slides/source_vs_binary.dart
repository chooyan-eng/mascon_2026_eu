import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

class SourceVsBinarySlide extends FlutterDeckSlideWidget {
  const SourceVsBinarySlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/source-vs-binary',
          title: '23. Source vs binary',
          steps: 2,
          speakerNotes:
              '- Source distribution: inspect and compile are close.\n'
              '- Binary distribution: another question remains — is this the source that produced the '
              'binary I actually consume?\n'
              '- [NEEDS VERIFICATION] Table contents to be re-checked against each ecosystem.',
        ),
      );

  static const _rows = [
    (eco: 'Dart / pub', form: 'source package', input: 'source', binary: false),
    (
      eco: 'CocoaPods source_files',
      form: 'source',
      input: 'source',
      binary: false,
    ),
    (eco: 'SwiftPM .target', form: 'source', input: 'source', binary: false),
    (
      eco: 'Maven / Gradle JAR / AAR',
      form: 'precompiled',
      input: 'binary artifact',
      binary: true,
    ),
    (
      eco: 'CocoaPods vendored framework',
      form: 'precompiled',
      input: 'framework / XCFramework',
      binary: true,
    ),
    (
      eco: 'SwiftPM .binaryTarget',
      form: 'precompiled',
      input: 'binary artifact',
      binary: true,
    ),
    (
      eco: 'DevTools extension',
      form: 'precompiled web output',
      input: 'compiled extension artifact',
      binary: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Provenance',
        headline: 'Source distribution vs binary distribution',
        pageNumber: '23',
        child: Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: DeckColors.line)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    for (final (flex, label) in const [
                      (6, 'ECOSYSTEM / MECHANISM'),
                      (4, 'TYPICAL FORM'),
                      (5, 'BUILD INPUT'),
                    ])
                      Expanded(
                        flex: flex,
                        child: Text(
                          label,
                          style: fig(
                            24,
                            color: DeckColors.faintest,
                            letterSpacing: 24 * 0.08,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              for (final (i, row) in _rows.indexed)
                Enter(
                  delayMs: 120 * i,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: DeckColors.rule),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Text(
                            row.eco,
                            style: fig(30, color: DeckColors.text),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            row.form,
                            style: fig(28, color: DeckColors.faint),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            row.input,
                            style: fig(
                              28,
                              color: row.binary
                                  ? DeckColors.accent
                                  : DeckColors.faint,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const Spacer(),
              Enter(
                step: 2,
                child: Text(
                  'Is this the source that produced the binary I actually consume?',
                  style: fig(36, color: DeckColors.accent),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
