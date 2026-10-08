import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Attack path: nothing in the package changed, but the artifact the hook
/// downloads was replaced upstream.
class PackageUnchangedSlide extends FlutterDeckSlideWidget {
  const PackageUnchangedSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/package-unchanged',
          title: '15. Package unchanged',
          steps: 2,
          speakerNotes:
              '- Key finding. Same package, same hook, same version, same pub content hash.\n'
              '- But the artifact the hook fetches was replaced upstream: the build input changed; '
              'the package did not.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Nothing in the package changed',
        pageNumber: '15',
        child: Staged(
          step: 2,
          builder: (context, swapped) {
            Widget chainRow(String label, {required bool today}) {
              final zipLit = today && swapped;
              return Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      label,
                      style: fig(48, italic: true, color: DeckColors.faint),
                    ),
                  ),
                  const OutlineBox(
                    'package 1.4.2',
                    width: 320,
                    height: 130,
                    fontSize: 30,
                    useMono: true,
                  ),
                  Container(width: 60, height: 1, color: DeckColors.line),
                  const OutlineBox(
                    'hook/build.dart',
                    width: 320,
                    height: 130,
                    fontSize: 30,
                    useMono: true,
                  ),
                  Container(width: 60, height: 1, color: DeckColors.line),
                  OutlineBox(
                    '',
                    width: 320,
                    height: 130,
                    borderColor: zipLit ? DeckColors.accent : DeckColors.line,
                    borderWidth: zipLit ? 2 : 1,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: zipLit
                          ? Column(
                              key: const ValueKey('swapped'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'tool.zip',
                                  style: mono(30, color: DeckColors.accent),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'replaced upstream',
                                  style: fig(
                                    26,
                                    color: DeckColors.accent,
                                    italic: true,
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              key: const ValueKey('same'),
                              child: Text(
                                'tool.zip',
                                style: mono(30, color: DeckColors.faint),
                              ),
                            ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Enter(child: chainRow('Yesterday', today: false)),
                const SizedBox(height: 72),
                Enter(delayMs: 300, child: chainRow('Today', today: true)),
                const SizedBox(height: 110),
                Enter(
                  step: 2,
                  delayMs: 900,
                  child: Center(
                    child: Text(
                      'Can this dependency change its behavior without changing itself?',
                      style: fig(42, italic: true),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
