import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Horizontal supply chain tree: My app on the left, dependencies flowing in
/// from upstream (right). One transitive package turns malicious and the
/// compromise travels right-to-left into the app.
class SupplyChainRiskSlide extends FlutterDeckSlideWidget {
  const SupplyChainRiskSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/supply-chain-risk',
          title: '05. Supply chain',
          steps: 2,
          speakerNotes:
              '- Our apps depend on a lot of packages and libraries.\n'
              '- But on a chain this complex, one compromised package somewhere deep is enough to reach my app.\n'
              '- I never chose Package F, but my app ships it anyway.\n'
              '- This is a supply chain attack. The risk keeps growing, and that is what I want to talk about today.',
        ),
      );

  // Gray wiring between the boxes (1920x1080 logical coordinates).
  static final _wiring = Path()
    ..moveTo(440, 540)
    ..lineTo(580, 540)
    ..moveTo(580, 300)
    ..lineTo(580, 780)
    ..moveTo(580, 300)
    ..lineTo(720, 300)
    ..moveTo(580, 540)
    ..lineTo(720, 540)
    ..moveTo(580, 780)
    ..lineTo(720, 780)
    ..moveTo(1000, 300)
    ..lineTo(1160, 300)
    ..moveTo(1160, 220)
    ..lineTo(1160, 380)
    ..moveTo(1160, 220)
    ..lineTo(1320, 220)
    ..moveTo(1160, 380)
    ..lineTo(1320, 380)
    ..moveTo(1000, 780)
    ..lineTo(1160, 780)
    ..moveTo(1160, 700)
    ..lineTo(1160, 860)
    ..moveTo(1160, 700)
    ..lineTo(1320, 700)
    ..moveTo(1160, 860)
    ..lineTo(1320, 860);

  // Contamination: F -> C, then C -> My app (drawn right to left).
  static final _pathFtoC = Path()
    ..moveTo(1320, 700)
    ..lineTo(1160, 700)
    ..lineTo(1160, 780)
    ..lineTo(1000, 780);
  static final _pathCtoApp = Path()
    ..moveTo(720, 780)
    ..lineTo(580, 780)
    ..lineTo(580, 540)
    ..lineTo(440, 540);

  // Unnamed stubs continuing to the right, faded out.
  static final _stubWiring = Path()
    ..moveTo(1600, 220)
    ..lineTo(1680, 220)
    ..moveTo(1680, 180)
    ..lineTo(1680, 260)
    ..moveTo(1680, 180)
    ..lineTo(1760, 180)
    ..moveTo(1680, 260)
    ..lineTo(1760, 260)
    ..moveTo(1600, 700)
    ..lineTo(1760, 700)
    ..moveTo(1600, 860)
    ..lineTo(1680, 860)
    ..moveTo(1680, 830)
    ..lineTo(1680, 890)
    ..moveTo(1680, 830)
    ..lineTo(1760, 830)
    ..moveTo(1680, 890)
    ..lineTo(1760, 890);

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        padded: false,
        kicker: 'Software supply chain',
        kickerRight: const Enter(dy: 0, child: UpstreamArrow()),
        pageNumber: '05',
        child: Enter(
          dy: 0,
          child: Staged(
            step: 2,
            builder: (context, lit) => Staged(
              step: 2,
              delayMs: 650,
              builder: (context, litC) => Staged(
                step: 2,
                delayMs: 1450,
                builder: (context, litApp) => Stack(
                  children: [
                    Positioned.fill(child: StrokePaths(path: _wiring)),
                    Positioned.fill(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF000000), Color(0x00000000)],
                          stops: [0.85, 0.98],
                        ).createShader(bounds),
                        blendMode: BlendMode.dstIn,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: StrokePaths(path: _stubWiring),
                            ),
                            for (final top in const [
                              156.0,
                              236.0,
                              676.0,
                              806.0,
                              866.0,
                            ])
                              Positioned(
                                left: 1760,
                                top: top,
                                child: const OutlineBox(
                                  '',
                                  width: 220,
                                  height: 48,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: PathDraw(path: _pathFtoC, step: 2, delayMs: 650),
                    ),
                    Positioned.fill(
                      child: PathDraw(
                        path: _pathCtoApp,
                        step: 2,
                        delayMs: 1450,
                      ),
                    ),
                    Positioned(
                      left: 160,
                      top: 492,
                      child: OutlineBox(
                        'My app',
                        width: 280,
                        height: 96,
                        fontSize: 48,
                        borderColor: litApp
                            ? DeckColors.accent
                            : DeckColors.line,
                        textColor: litApp ? DeckColors.accent : DeckColors.text,
                      ),
                    ),
                    const Positioned(
                      left: 720,
                      top: 252,
                      child: OutlineBox('Package A', width: 280, height: 96),
                    ),
                    const Positioned(
                      left: 720,
                      top: 492,
                      child: OutlineBox('Package B', width: 280, height: 96),
                    ),
                    Positioned(
                      left: 720,
                      top: 732,
                      child: OutlineBox(
                        'Package C',
                        width: 280,
                        height: 96,
                        borderColor: litC ? DeckColors.accent : DeckColors.line,
                        textColor: litC ? DeckColors.accent : DeckColors.faint,
                      ),
                    ),
                    const Positioned(
                      left: 1320,
                      top: 172,
                      child: OutlineBox('Package D', width: 280, height: 96),
                    ),
                    const Positioned(
                      left: 1320,
                      top: 332,
                      child: OutlineBox('Package E', width: 280, height: 96),
                    ),
                    Positioned(
                      left: 1320,
                      top: 652,
                      child: OutlineBox(
                        'Package F',
                        width: 280,
                        height: 96,
                        borderColor: lit ? DeckColors.accent : DeckColors.line,
                        borderWidth: lit ? 2 : 1,
                        textColor: lit ? DeckColors.accent : DeckColors.faint,
                      ),
                    ),
                    const Positioned(
                      left: 1320,
                      top: 812,
                      child: OutlineBox('Package G', width: 280, height: 96),
                    ),
                    Positioned(
                      left: 1320,
                      top: 758,
                      width: 280,
                      child: AnimatedOpacity(
                        opacity: lit ? 1 : 0,
                        duration: const Duration(milliseconds: 700),
                        child: Text(
                          'compromised',
                          textAlign: TextAlign.center,
                          style: fig(
                            28,
                            color: DeckColors.accent,
                            italic: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
