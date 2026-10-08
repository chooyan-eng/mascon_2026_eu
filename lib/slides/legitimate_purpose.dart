import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Build hooks exist for good reasons: bullets on top, and below a build
/// pipeline band where hook/build.dart boxes drop onto the `flutter build`
/// line between compile and link.
class LegitimatePurposeSlide extends FlutterDeckSlideWidget {
  const LegitimatePurposeSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/legitimate-purpose',
          title: '12. What build hooks do',
          steps: 2,
          speakerNotes:
              '- Overview and typical uses. Injecting work into the build is an ordinary mechanism: '
              'Gradle, CocoaPods and SwiftPM have the same idea.\n'
              '- Benefit: Flutter builds for many platforms; instead of bundling everything up front, '
              'a hook prepares just the right resources for the target platform at build time.\n'
              '- Hooks are part of the normal flutter build: they run between fetching packages and '
              'linking the app. Download and process execution are not, by themselves, suspicious here.\n'
              '- This matters later for detection.',
        ),
      );

  static const _bullets = [
    'Native code compilation',
    'Native asset preparation',
    'Prebuilt native asset download',
    'Linking information preparation',
    'Platform-specific build integration',
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        padded: false,
        kicker: 'Build hooks',
        headline: 'What build hooks do',
        pageNumber: '12',
        child: Stack(
          children: [
            Positioned(
              left: 120,
              top: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, bullet) in _bullets.indexed)
                    Enter(
                      delayMs: 200 * i,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: DeckColors.accent,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Text(bullet, style: fig(40, color: DeckColors.sub)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Build pipeline band with the repeating left-to-right sweep.
            const Positioned.fill(child: _PipelineBand()),
          ],
        ),
      ),
    );
  }
}

/// The pipeline band: hairline, stage boxes and the hook boxes, plus a gold
/// sweep that flows left to right on repeat. Each element lights up as the
/// sweep head reaches it and fades after it has passed.
class _PipelineBand extends StatefulWidget {
  const _PipelineBand();

  @override
  State<_PipelineBand> createState() => _PipelineBandState();
}

class _PipelineBandState extends State<_PipelineBand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4200),
  );

  @override
  void initState() {
    super.initState();
    if (deckLoopingAnimations) {
      // Start the sweep only once the band's entrance animation has
      // finished (Enter: 1100ms delay + 700ms duration).
      Future.delayed(const Duration(milliseconds: 1900), () {
        if (mounted) _sweep.repeat();
      });
    }
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  /// Sweep head x in slide coordinates. The run takes the first 80% of the
  /// cycle; the remaining 20% is a pause with the head parked off-screen.
  double _headX(double v) {
    final t = (v / 0.8).clamp(0.0, 1.0);
    return 40 + t * (1960 - 40);
  }

  /// 0..1 highlight: rises sharply as the head arrives at [cx], decays
  /// slowly after it has passed.
  double _glow(double head, double cx) {
    final d = head - cx;
    final s = d < 0 ? 90.0 : 320.0;
    return math.exp(-(d / s) * (d / s));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sweep,
      builder: (context, _) {
        final head = _headX(_sweep.value);
        return Stack(
          children: [
            Positioned.fill(
              child: Enter(
                delayMs: 1100,
                dy: 0,
                child: Stack(
                  children: [
                    Positioned(
                      left: 120,
                      right: 120,
                      top: 880,
                      child: Container(height: 1, color: DeckColors.line),
                    ),
                    Positioned(
                      left: 120,
                      right: 120,
                      top: 879,
                      height: 3,
                      child: CustomPaint(painter: _SweepPainter(head - 120)),
                    ),
                    Positioned(
                      left: 120,
                      top: 828,
                      child: Text(
                        r'$ flutter build',
                        style: mono(24, color: DeckColors.faintest),
                      ),
                    ),
                    Positioned(
                      left: 420,
                      top: 846,
                      child: _StageBox(
                        'compile',
                        width: 220,
                        glow: _glow(head, 530),
                      ),
                    ),
                    Positioned(
                      left: 1400,
                      top: 846,
                      child: _StageBox(
                        'link',
                        width: 180,
                        glow: _glow(head, 1490),
                      ),
                    ),
                    Positioned(
                      left: 1620,
                      top: 846,
                      child: _StageBox(
                        'app',
                        width: 180,
                        glow: _glow(head, 1710),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Hooks dropping in between compile and link (step 2); once
            // visible they join the sweep highlight like the stages.
            for (final (i, left) in const [690.0, 1040.0].indexed)
              Positioned(
                left: left,
                top: 786,
                child: Enter(
                  step: 2,
                  delayMs: 250 * i,
                  durationMs: 1200,
                  dy: -60,
                  child: Transform.scale(
                    scale: 1 + 0.05 * _glow(head, left + 160),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i == 0 ? 'package_a' : 'package_b',
                          style: mono(
                            24,
                            color: Color.lerp(
                              DeckColors.faintest,
                              DeckColors.accent,
                              _glow(head, left + 160),
                            )!,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlineBox(
                          'hook/build.dart',
                          width: 320,
                          height: 68,
                          fontSize: 24,
                          useMono: true,
                          borderColor: DeckColors.accent,
                          borderWidth: 2,
                          textColor: DeckColors.accent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Gold gradient segment trailing behind the sweep head on the hairline.
class _SweepPainter extends CustomPainter {
  _SweepPainter(this.head);

  /// Head x position in the painter's local coordinates.
  final double head;

  @override
  void paint(Canvas canvas, Size size) {
    const tail = 280.0;
    final x1 = head.clamp(0.0, size.width);
    final x0 = (head - tail).clamp(0.0, size.width);
    if (x1 - x0 < 1) return;
    final shaderRect = Rect.fromLTRB(head - tail, 0, head, size.height);
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          DeckColors.accent.withValues(alpha: 0),
          DeckColors.accent,
        ],
      ).createShader(shaderRect);
    canvas.drawRect(Rect.fromLTRB(x0, 0, x1, size.height), paint);
  }

  @override
  bool shouldRepaint(_SweepPainter old) => old.head != head;
}

class _StageBox extends StatelessWidget {
  const _StageBox(this.label, {required this.width, this.glow = 0});

  final String label;
  final double width;

  /// 0..1 sweep highlight intensity.
  final double glow;

  @override
  Widget build(BuildContext context) {
    // Solid background hides the hairline running behind the box.
    return Transform.scale(
      scale: 1 + 0.04 * glow,
      child: Container(
        width: width,
        height: 68,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: DeckColors.background,
          border: Border.all(
            color: Color.lerp(DeckColors.line, DeckColors.accent, glow)!,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: fig(
            30,
            color: Color.lerp(DeckColors.faint, DeckColors.accent, glow)!,
          ),
        ),
      ),
    );
  }
}
