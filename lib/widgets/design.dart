import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';

/// Design-language widgets for the Claude Design redesign
/// (docs/design_handoff_mascon_deck/README.md).
///
/// Stage model: flutter_deck steps are the "click" stages. "Auto" stages are
/// entrance animations scheduled with a delay once their step becomes active
/// ([Staged.delayMs]).

const kSocialHandle = '@tsuyoshi_chujo';

/// Whether looping (repeating) animations run. Widget tests set this to
/// false: a repeating animation never settles under pumpAndSettle.
bool deckLoopingAnimations = true;

/// Runs [builder] with `shown == true` once the current flutter_deck step is
/// `>= step` and [delayMs] has elapsed. Going back a step resets it.
class Staged extends StatefulWidget {
  const Staged({
    required this.builder,
    this.step = 1,
    this.delayMs = 0,
    super.key,
  });

  final int step;
  final int delayMs;
  final Widget Function(BuildContext context, bool shown) builder;

  @override
  State<Staged> createState() => _StagedState();
}

class _StagedState extends State<Staged> {
  bool _shown = false;
  bool? _lastActive;
  int _generation = 0;

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlideStepsBuilder(
      builder: (context, step) {
        final active = step >= widget.step;
        if (active != _lastActive) {
          _lastActive = active;
          final gen = ++_generation;
          Future.delayed(
            Duration(milliseconds: active ? 1 + widget.delayMs : 1),
            () {
              if (mounted && gen == _generation) {
                setState(() => _shown = active);
              }
            },
          );
        }
        return widget.builder(context, _shown);
      },
    );
  }
}

/// Entrance: opacity 0 -> 1 and translateY 28 -> 0, 700ms ease-out.
class Enter extends StatelessWidget {
  const Enter({
    required this.child,
    this.step = 1,
    this.delayMs = 0,
    this.durationMs = 700,
    this.dy = 28,
    super.key,
  });

  final Widget child;
  final int step;
  final int delayMs;
  final int durationMs;
  final double dy;

  @override
  Widget build(BuildContext context) {
    return Staged(
      step: step,
      delayMs: delayMs,
      builder: (context, shown) => AnimatedContainer(
        duration: Duration(milliseconds: durationMs),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, shown ? 0 : dy, 0),
        child: AnimatedOpacity(
          opacity: shown ? 1 : 0,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.easeOut,
          child: child,
        ),
      ),
    );
  }
}

/// A line that grows horizontally (scaleX 0 -> 1) from [alignment].
class GrowLine extends StatelessWidget {
  const GrowLine({
    this.step = 1,
    this.delayMs = 0,
    this.durationMs = 1200,
    this.thickness = 1,
    this.color = DeckColors.accent,
    this.alignment = Alignment.centerLeft,
    super.key,
  });

  final int step;
  final int delayMs;
  final int durationMs;
  final double thickness;
  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Staged(
      step: step,
      delayMs: delayMs,
      builder: (context, shown) => AnimatedContainer(
        duration: Duration(milliseconds: durationMs),
        curve: const Cubic(.2, .7, .2, 1),
        transform: Matrix4.diagonal3Values(shown ? 1 : 0.001, 1, 1),
        transformAlignment: alignment,
        height: thickness,
        color: color,
      ),
    );
  }
}

/// Left-top small mono label in gold.
class Kicker extends StatelessWidget {
  const Kicker(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: mono(24, color: DeckColors.accent, letterSpacing: 24 * 0.08),
    );
  }
}

/// Long left-pointing arrow with an italic `upstream` label (top right of
/// the horizontal flow slides).
class UpstreamArrow extends StatelessWidget {
  const UpstreamArrow({this.width = 560, super.key});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(size: Size(width, 16), painter: _ArrowPainter()),
        const SizedBox(width: 24),
        Text(
          'upstream',
          style: fig(28, color: DeckColors.faintest, italic: true),
        ),
      ],
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DeckColors.gray
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final midY = size.height / 2;
    canvas.drawLine(Offset(size.width, midY), Offset(2, midY), paint);
    canvas.drawLine(const Offset(16, 1), Offset(2, midY), paint);
    canvas.drawLine(Offset(2, midY), const Offset(16, 15), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Standard page scaffold: 120px side / 96px top padding, kicker + h2,
/// footer with handle and 2-digit page number (44px from the bottom).
class DesignSlide extends StatelessWidget {
  const DesignSlide({
    required this.child,
    this.kicker,
    this.kickerRight,
    this.headline,
    this.pageNumber,
    this.padded = true,
    super.key,
  });

  final Widget child;
  final String? kicker;
  final Widget? kickerRight;
  final String? headline;
  final String? pageNumber;

  /// Set to false when the body is absolutely positioned (full-bleed).
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final header = (kicker != null || headline != null)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (kicker != null)
                Row(children: [Kicker(kicker!), const Spacer(), ?kickerRight]),
              if (headline != null) ...[
                const SizedBox(height: 20),
                Text(headline!, style: fig(62, height: 1)),
              ],
            ],
          )
        : null;

    final body = padded
        ? Padding(
            padding: const EdgeInsets.fromLTRB(120, 96, 120, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ?header,
                Expanded(child: child),
              ],
            ),
          )
        : Stack(
            children: [
              Positioned.fill(child: child),
              if (header != null)
                Positioned(left: 120, right: 120, top: 96, child: header),
            ],
          );

    return ColoredBox(
      color: DeckColors.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          body,
          if (pageNumber != null)
            Positioned(
              left: 96,
              right: 96,
              bottom: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    kSocialHandle,
                    style: fig(24, color: DeckColors.faintest),
                  ),
                  Text(pageNumber!, style: fig(24, color: DeckColors.faintest)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Outlined label box (1px border, 4px radius). Border / text colors animate
/// so a box can "light up" in gold.
class OutlineBox extends StatelessWidget {
  const OutlineBox(
    this.label, {
    this.width,
    this.height,
    this.fontSize = 44,
    this.borderColor = DeckColors.line,
    this.borderWidth = 1,
    this.textColor = DeckColors.faint,
    this.useMono = false,
    this.child,
    super.key,
  });

  final String label;
  final double? width;
  final double? height;
  final double fontSize;
  final Color borderColor;
  final double borderWidth;
  final Color textColor;
  final bool useMono;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(4),
      ),
      child:
          child ??
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            style: useMono
                ? mono(fontSize, color: textColor)
                : fig(fontSize, color: textColor),
            textAlign: TextAlign.center,
            child: Text(label, textAlign: TextAlign.center),
          ),
    );
  }
}

/// Number counting up from 0 (or [from]) to [value].
class CountUp extends StatelessWidget {
  const CountUp(
    this.value, {
    required this.style,
    this.from = 0,
    this.durationMs = 1800,
    super.key,
  });

  final int value;
  final int from;
  final int durationMs;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: from.toDouble(), end: value.toDouble()),
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text('${v.round()}', style: style),
    );
  }
}

/// Code block: near-black background, hairline border, mono 26px.
class CodeBlock extends StatelessWidget {
  const CodeBlock(this.code, {super.key});

  /// Code to display. Wrap the key operation in `«…»` to render that span in
  /// gold (markers are stripped).
  final String code;

  List<TextSpan> _spans(String line) {
    final spans = <TextSpan>[];
    var rest = line;
    while (rest.isNotEmpty) {
      final open = rest.indexOf('«');
      if (open < 0) {
        spans.add(TextSpan(text: rest));
        break;
      }
      if (open > 0) spans.add(TextSpan(text: rest.substring(0, open)));
      final close = rest.indexOf('»', open);
      final end = close < 0 ? rest.length : close;
      spans.add(
        TextSpan(
          text: rest.substring(open + 1, end),
          style: const TextStyle(color: DeckColors.accent),
        ),
      );
      rest = close < 0 ? '' : rest.substring(close + 1);
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final lines = code.split('\n');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 44),
      decoration: BoxDecoration(
        color: DeckColors.codeBackground,
        border: Border.all(color: DeckColors.rule),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in lines)
            Text.rich(
              TextSpan(children: _spans(line.isEmpty ? ' ' : line)),
              style: mono(26, color: DeckColors.text, height: 1.6),
            ),
        ],
      ),
    );
  }
}

/// Draws [path] progressively (like SVG stroke-dashoffset 1 -> 0) once its
/// step becomes active. Coordinates are in the slide's logical space; place
/// inside a Positioned.fill.
class PathDraw extends StatelessWidget {
  const PathDraw({
    required this.path,
    this.step = 1,
    this.delayMs = 0,
    this.durationMs = 700,
    this.color = DeckColors.accent,
    this.strokeWidth = 3,
    super.key,
  });

  final Path path;
  final int step;
  final int delayMs;
  final int durationMs;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Staged(
      step: step,
      delayMs: delayMs,
      builder: (context, shown) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: shown ? 1 : 0),
        duration: Duration(milliseconds: durationMs),
        curve: Curves.easeOut,
        builder: (context, t, _) => CustomPaint(
          painter: _PartialPathPainter(
            path: path,
            progress: t,
            color: color,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _PartialPathPainter extends CustomPainter {
  _PartialPathPainter({
    required this.path,
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final Path path;
  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
    }
  }

  @override
  bool shouldRepaint(_PartialPathPainter old) =>
      old.progress != progress || old.color != color || old.path != path;
}

/// Static polyline strokes (the gray "wiring" of diagram slides).
class StrokePaths extends StatelessWidget {
  const StrokePaths({
    required this.path,
    this.color = DeckColors.line,
    this.strokeWidth = 1.5,
    super.key,
  });

  final Path path;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PartialPathPainter(
        path: path,
        progress: 1,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

/// Small outlined chip with mono text (trust-boundary checklist etc.).
class Chip24 extends StatelessWidget {
  const Chip24(this.text, {this.size = 24, super.key});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: DeckColors.line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: mono(size, color: DeckColors.faint)),
    );
  }
}
