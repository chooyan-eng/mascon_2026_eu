import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// A Flutter app also pulls in native package managers and precompiled
/// binaries — the layers below Dart.
class BeyondDartSlide extends FlutterDeckSlideWidget {
  const BeyondDartSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/beyond-dart',
          title: '22. Beyond Dart',
          speakerNotes:
              '- All of that was Dart / Flutter packages only.\n'
              '- A Flutter app also pulls in Android and iOS native libraries through Gradle, CocoaPods '
              'and SwiftPM — often as precompiled artifacts — and the same thinking applies there.',
        ),
      );

  static const _layers = [
    (label: 'Flutter app', note: '', gold: false),
    (label: 'Dart packages', note: 'pub', gold: false),
    (label: 'Flutter plugins', note: 'Android / iOS code inside', gold: false),
    (
      label: 'Gradle · CocoaPods · SwiftPM',
      note: 'other package managers',
      gold: true,
    ),
    (
      label: 'JAR / AAR · frameworks · binaries',
      note: 'often precompiled',
      gold: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Beyond Dart',
        headline: 'A Flutter app depends on more than Dart',
        pageNumber: '22',
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (i, layer) in _layers.indexed) ...[
                if (i > 0)
                  Enter(
                    delayMs: 250 * i - 100,
                    dy: 0,
                    // Keep the connector centered on the 720px box, not on the
                    // box + note row.
                    child: Padding(
                      padding: const EdgeInsets.only(right: 400),
                      child: Container(
                        width: 1,
                        height: 36,
                        color: DeckColors.line,
                      ),
                    ),
                  ),
                Enter(
                  delayMs: 250 * i,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlineBox(
                        layer.label,
                        width: 720,
                        height: 88,
                        fontSize: 36,
                        borderColor: layer.gold
                            ? DeckColors.accent
                            : DeckColors.line,
                        textColor: layer.gold
                            ? DeckColors.accent
                            : DeckColors.text,
                      ),
                      SizedBox(
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Text(
                            layer.note,
                            style: fig(26, color: DeckColors.faint),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
