import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';
import '../widgets/web_view_dialog.dart';

/// The software supply chain is more than packages: eight lanes flow into
/// My app from upstream. On click, only the Packages lane stays lit.
class SupplyChainSlide extends FlutterDeckSlideWidget {
  const SupplyChainSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/supply-chain',
          title: '08. More than packages',
          steps: 2,
          speakerNotes:
              '- By the way, a supply chain is more than packages: CI, IDE extensions, build tools and so on.\n'
              '- The list is based on the OWASP Software Supply Chain Security Cheat Sheet.\n'
              '- Today I focus on packages and libraries.',
        ),
      );

  static const _lanes = [
    (label: 'Version control', y: 250.0),
    (label: 'Build tool', y: 340.0),
    (label: 'CI', y: 430.0),
    (label: 'IDE extension', y: 520.0),
    (label: 'Packages', y: 610.0),
    (label: 'Package registry', y: 700.0),
    (label: 'Container image', y: 790.0),
    (label: 'Binary artifact', y: 880.0),
  ];

  static Path _curve(double y) => Path()
    ..moveTo(900, y)
    ..lineTo(580, y)
    ..cubicTo(500, y, 500, 540, 440, 540);

  static Path _fadeLine(double y) => Path()
    ..moveTo(720, y)
    ..lineTo(0, y);

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        padded: false,
        kicker: 'Software supply chain',
        kickerRight: const Enter(dy: 0, child: UpstreamArrow()),
        pageNumber: '08',
        child: Enter(
          dy: 0,
          child: Staged(
            step: 2,
            builder: (context, focus) {
              Color laneColor(String label) => label == 'Packages'
                  ? DeckColors.accent
                  : (focus ? DeckColors.rule : DeckColors.line);
              Color textColor(String label) => label == 'Packages'
                  ? (focus ? DeckColors.accent : DeckColors.faint)
                  : (focus ? DeckColors.rule : DeckColors.faint);
              double laneWidth(String label) => label == 'Packages' ? 2.5 : 1.5;

              return Stack(
                children: [
                  // Curves from the lane boxes into My app.
                  for (final lane in _lanes)
                    Positioned.fill(
                      child: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(end: laneColor(lane.label)),
                        duration: const Duration(milliseconds: 700),
                        builder: (context, color, _) => StrokePaths(
                          path: _curve(lane.y),
                          color: color ?? DeckColors.line,
                          strokeWidth: laneWidth(lane.label),
                        ),
                      ),
                    ),
                  // Lines continuing upstream, fading out to the right.
                  Positioned(
                    left: 1200,
                    top: 0,
                    width: 720,
                    height: 1080,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF000000), Color(0x00000000)],
                        stops: [0.3, 0.95],
                      ).createShader(bounds),
                      blendMode: BlendMode.dstIn,
                      child: Stack(
                        children: [
                          for (final lane in _lanes)
                            Positioned.fill(
                              child: TweenAnimationBuilder<Color?>(
                                tween: ColorTween(end: laneColor(lane.label)),
                                duration: const Duration(milliseconds: 700),
                                builder: (context, color, _) => StrokePaths(
                                  path: _fadeLine(lane.y),
                                  color: color ?? DeckColors.line,
                                  strokeWidth: laneWidth(lane.label),
                                ),
                              ),
                            ),
                        ],
                      ),
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
                      textColor: DeckColors.text,
                    ),
                  ),
                  for (final lane in _lanes)
                    Positioned(
                      left: 900,
                      top: lane.y - 34,
                      child: OutlineBox(
                        lane.label,
                        width: 300,
                        height: 68,
                        fontSize: 30,
                        borderColor: laneColor(lane.label),
                        borderWidth: lane.label == 'Packages' && focus ? 2 : 1,
                        textColor: textColor(lane.label),
                      ),
                    ),
                  Positioned(
                    left: 120,
                    bottom: 110,
                    child: MouseRegion(
                      cursor: webViewSupported
                          ? SystemMouseCursors.click
                          : MouseCursor.defer,
                      child: GestureDetector(
                        onTap: webViewSupported
                            ? () => openWebViewDialog(
                                context,
                                'https://cheatsheetseries.owasp.org/cheatsheets'
                                '/Software_Supply_Chain_Security_Cheat_Sheet.html',
                              )
                            : null,
                        child: Text(
                          'Source: cheatsheetseries.owasp.org/cheatsheets'
                          '/Software_Supply_Chain_Security_Cheat_Sheet.html'
                          '${webViewSupported ? '  ↗' : ''}',
                          style: mono(18, color: DeckColors.faintest),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
