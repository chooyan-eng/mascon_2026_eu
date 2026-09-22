// Interactive dependency graph (pan / zoom / hover / select).
// Ported and simplified from dependency_inspector app/lib/src/widgets/graph_view.dart.
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'graph_model.dart';

/// Colors per ecosystem.
Color ecoColor(Ecosystem eco) => switch (eco) {
  Ecosystem.dart => const Color(0xFF5CC8FF),
  Ecosystem.ios => const Color(0xFFD7A6FF),
  Ecosystem.android => const Color(0xFF7BD88F),
};

String ecoLabel(Ecosystem eco) => switch (eco) {
  Ecosystem.dart => 'Dart',
  Ecosystem.ios => 'iOS',
  Ecosystem.android => 'Android',
};

/// Node shape path centered at the origin.
Path shapePathFor(NodeKind kind, double r) {
  final path = Path();
  switch (kind) {
    case NodeKind.dartPackage:
      path.addOval(Rect.fromCircle(center: Offset.zero, radius: r));
    case NodeKind.pod:
      final h = r * 0.92;
      path.addRect(Rect.fromLTRB(-h, -h, h, h));
    case NodeKind.swiftpmPackage:
      final h = r * 1.2;
      path
        ..moveTo(0, -h)
        ..lineTo(h, 0)
        ..lineTo(0, h)
        ..lineTo(-h, 0)
        ..close();
    case NodeKind.mavenArtifact:
      for (var i = 0; i < 6; i++) {
        final a = math.pi / 3 * i - math.pi / 6;
        final x = math.cos(a) * r * 1.12, y = math.sin(a) * r * 1.12;
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      path.close();
    case NodeKind.gradlePlugin:
      final h = r * 1.25;
      path
        ..moveTo(0, -h)
        ..lineTo(h * 0.95, h * 0.72)
        ..lineTo(-h * 0.95, h * 0.72)
        ..close();
    case NodeKind.bundledBinary:
      final h = r * 0.9;
      path
        ..moveTo(-h, -h)
        ..lineTo(h * 0.45, -h)
        ..lineTo(h, -h * 0.45)
        ..lineTo(h, h)
        ..lineTo(-h, h)
        ..close();
  }
  return path;
}

/// Interactive canvas. [visible] decides which nodes are drawn; when it
/// changes the view animates to fit the new set.
class DependencyGraphView extends StatefulWidget {
  const DependencyGraphView({
    required this.graph,
    required this.visible,
    this.onSelectionChanged,
    super.key,
  });

  final GraphData graph;
  final Set<int> visible;
  final ValueChanged<int?>? onSelectionChanged;

  @override
  State<DependencyGraphView> createState() => DependencyGraphViewState();
}

class DependencyGraphViewState extends State<DependencyGraphView> with SingleTickerProviderStateMixin {
  // View transform: screen = world * k + (tx, ty).
  double _tx = 0, _ty = 0, _k = 1;
  Size _size = Size.zero;
  bool _fitted = false;

  int? _hover;
  int? _sel;

  Offset? _dragStart;
  (double, double)? _dragOrigin;
  double _dragMoved = 0;
  bool _justDragged = false;

  double _pzK = 1, _pzTx = 0, _pzTy = 0;

  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..addListener(_onAnim);
  (double, double, double)? _from, _to;

  GraphData get g => widget.graph;

  @override
  void didUpdateWidget(covariant DependencyGraphView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible.length != widget.visible.length) {
      if (_sel != null && !widget.visible.contains(_sel)) _select(null);
      WidgetsBinding.instance.addPostFrameCallback((_) => fitView());
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _onAnim() {
    if (_from == null || _to == null) return;
    final t = Curves.easeInOutCubic.transform(_anim.value);
    setState(() {
      _tx = ui.lerpDouble(_from!.$1, _to!.$1, t)!;
      _ty = ui.lerpDouble(_from!.$2, _to!.$2, t)!;
      _k = ui.lerpDouble(_from!.$3, _to!.$3, t)!;
    });
  }

  /// Fits the visible nodes into the canvas.
  void fitView({bool animate = true}) {
    if (_size == Size.zero || !mounted) return;
    var x0 = double.infinity, y0 = double.infinity, x1 = -double.infinity, y1 = -double.infinity;
    for (final i in widget.visible) {
      final n = g.nodes[i];
      x0 = math.min(x0, n.x);
      y0 = math.min(y0, n.y);
      x1 = math.max(x1, n.x);
      y1 = math.max(y1, n.y);
    }
    const margin = 120.0;
    final k = math.min(_size.width / (x1 - x0 + margin), _size.height / (y1 - y0 + margin)).clamp(0.15, 3.0);
    final tx = _size.width / 2 - (x0 + x1) / 2 * k;
    final ty = _size.height / 2 - (y0 + y1) / 2 * k;
    if (!animate) {
      setState(() {
        _tx = tx;
        _ty = ty;
        _k = k;
      });
      return;
    }
    _from = (_tx, _ty, _k);
    _to = (tx, ty, k);
    _anim.forward(from: 0);
  }

  double _radius(int i) => i == g.rootIndex ? 16 : (g.isDirect(i) ? 9 : 6);

  int? _hitTest(Offset local) {
    final wx = (local.dx - _tx) / _k, wy = (local.dy - _ty) / _k;
    int? hit;
    for (final i in widget.visible) {
      final n = g.nodes[i];
      final r = math.max(_radius(i), 8.0) + 4;
      final dx = wx - n.x, dy = wy - n.y;
      if (dx * dx + dy * dy <= r * r) hit = i;
    }
    return hit;
  }

  void _select(int? i) {
    setState(() => _sel = i);
    widget.onSelectionChanged?.call(i);
  }

  void _zoomAt(Offset local, double nk) {
    _anim.stop();
    nk = nk.clamp(0.12, 6.0);
    setState(() {
      _tx = local.dx - (local.dx - _tx) * nk / _k;
      _ty = local.dy - (local.dy - _ty) * nk / _k;
      _k = nk;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (size != _size) {
          _size = size;
          if (!_fitted) {
            _fitted = true;
            WidgetsBinding.instance.addPostFrameCallback((_) => fitView(animate: false));
          }
        }
        return ClipRect(
          child: MouseRegion(
            cursor: _dragStart != null
                ? SystemMouseCursors.grabbing
                : (_hover != null ? SystemMouseCursors.click : SystemMouseCursors.grab),
            onHover: (e) {
              final hit = _hitTest(e.localPosition);
              if (hit != _hover) setState(() => _hover = hit);
            },
            onExit: (_) => setState(() => _hover = null),
            child: Listener(
              onPointerSignal: (e) {
                if (e is PointerScrollEvent) {
                  _zoomAt(e.localPosition, _k * math.exp(-e.scrollDelta.dy * 0.0016));
                }
              },
              // Trackpad: two-finger scroll = pan, pinch = zoom.
              onPointerPanZoomStart: (e) {
                _anim.stop();
                _pzK = _k;
                _pzTx = _tx;
                _pzTy = _ty;
              },
              onPointerPanZoomUpdate: (e) {
                final nk = (_pzK * e.scale).clamp(0.12, 6.0);
                final p = e.localPosition;
                setState(() {
                  _tx = p.dx - (p.dx - _pzTx) * nk / _pzK + e.pan.dx;
                  _ty = p.dy - (p.dy - _pzTy) * nk / _pzK + e.pan.dy;
                  _k = nk;
                });
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                supportedDevices: const {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus},
                onPanStart: (d) {
                  _anim.stop();
                  _dragStart = d.localPosition;
                  _dragOrigin = (_tx, _ty);
                  _dragMoved = 0;
                },
                onPanUpdate: (d) {
                  if (_dragStart == null) return;
                  final delta = d.localPosition - _dragStart!;
                  _dragMoved = math.max(_dragMoved, delta.distance);
                  setState(() {
                    _tx = _dragOrigin!.$1 + delta.dx;
                    _ty = _dragOrigin!.$2 + delta.dy;
                  });
                },
                onPanEnd: (_) => setState(() {
                  _justDragged = _dragMoved > 4;
                  _dragStart = null;
                }),
                onPanCancel: () => setState(() => _dragStart = null),
                onTapUp: (d) {
                  if (_justDragged) {
                    _justDragged = false;
                    return;
                  }
                  final hit = _hitTest(d.localPosition);
                  _select(hit == _sel ? null : hit);
                },
                onDoubleTap: fitView,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _GraphPainter(
                    graph: g,
                    visible: widget.visible,
                    tx: _tx,
                    ty: _ty,
                    k: _k,
                    hover: _hover,
                    sel: _sel,
                    radius: _radius,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GraphPainter extends CustomPainter {
  _GraphPainter({
    required this.graph,
    required this.visible,
    required this.tx,
    required this.ty,
    required this.k,
    required this.hover,
    required this.sel,
    required this.radius,
  });

  final GraphData graph;
  final Set<int> visible;
  final double tx, ty, k;
  final int? hover, sel;
  final double Function(int) radius;

  static final _labelCache = <String, TextPainter>{};

  static const _downColor = DeckColors.accent;
  static const _upColor = Color(0xFF5CC8FF);

  @override
  void paint(Canvas canvas, Size size) {
    final g = graph;
    final down = sel != null ? g.closure(sel!, out: true, visible: visible) : null;
    final up = sel != null ? g.closure(sel!, out: false, visible: visible) : null;
    final related = sel != null ? {...down!, ...up!} : null;

    canvas.save();
    canvas.translate(tx, ty);
    canvas.scale(k);

    // ---- Edges. Plain edges are batched into one path per style. ----
    final plain = Path();
    final cross = Path();
    final faded = Path();
    final emphasized = <(GraphEdge, Color)>[];

    for (final e in g.edges) {
      if (!visible.contains(e.source) || !visible.contains(e.target)) continue;
      if (sel != null) {
        if (down!.contains(e.source) && down.contains(e.target)) {
          emphasized.add((e, _downColor));
        } else if (up!.contains(e.source) && up.contains(e.target)) {
          emphasized.add((e, _upColor));
        } else {
          _addCurve(faded, e);
        }
        continue;
      }
      if (hover != null && (e.source == hover || e.target == hover)) {
        emphasized.add((e, DeckColors.onSurface));
        continue;
      }
      _addCurve(g.eco[e.source] != g.eco[e.target] ? cross : plain, e);
    }

    Paint stroke(Color c, double w) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w / math.sqrt(k)
      ..color = c;
    canvas.drawPath(faded, stroke(DeckColors.muted.withValues(alpha: 0.05), 1));
    canvas.drawPath(plain, stroke(DeckColors.muted.withValues(alpha: hover != null ? 0.12 : 0.28), 1));
    canvas.drawPath(cross, stroke(DeckColors.accent.withValues(alpha: hover != null ? 0.15 : 0.4), 1.2));

    for (final (e, color) in emphasized) {
      final path = Path();
      final end = _addCurve(path, e);
      canvas.drawPath(path, stroke(color.withValues(alpha: 0.95), 2));
      if (end == null) continue;
      // Arrow head always points at the dependency.
      final (ex, ey, tdx, tdy) = end;
      final hs = (9 / k).clamp(5.0, 14.0);
      final bx = ex - tdx * hs, by = ey - tdy * hs;
      canvas.drawPath(
        Path()
          ..moveTo(ex, ey)
          ..lineTo(bx - tdy * hs * 0.42, by + tdx * hs * 0.42)
          ..lineTo(bx + tdy * hs * 0.42, by - tdx * hs * 0.42)
          ..close(),
        Paint()..color = color,
      );
    }

    // ---- Nodes ----
    for (final i in visible) {
      final n = g.nodes[i];
      final isRoot = i == g.rootIndex;
      final isSel = sel == i;
      final hovered = hover == i;
      final base = radius(i);
      var o = 1.0;
      if (sel != null && !related!.contains(i)) o = 0.12;

      canvas.save();
      canvas.translate(n.x, n.y);

      if (isSel) {
        canvas.drawCircle(
          Offset.zero,
          base + 6,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = DeckColors.accent,
        );
      }

      final color = isRoot ? DeckColors.accent : ecoColor(g.eco[i]);
      final shape = shapePathFor(n.kind, base);
      final filled = isRoot || g.isDirect(i);
      canvas.drawPath(
        shape,
        Paint()..color = (filled ? color : DeckColors.background).withValues(alpha: filled ? o * 0.9 : o),
      );
      canvas.drawPath(
        shape,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = hovered || isSel ? 2.4 : 1.4
          ..color = color.withValues(alpha: o),
      );

      final showLabel = isRoot || isSel || hovered || (o == 1.0 && (g.isDirect(i) ? k >= 0.9 : k >= 1.7)) ||
          (sel != null && related!.contains(i) && k >= 0.9);
      if (showLabel && o > 0.5) {
        final emphasized = isRoot || isSel || hovered;
        final fs = isRoot ? 16.0 : (emphasized ? 14.0 : 10.5);
        final text = n.name.length > 32 ? '${n.name.substring(0, 30)}…' : n.name;
        final painter = _label(text, fs, emphasized ? DeckColors.onSurface : DeckColors.muted, emphasized);
        final offset = Offset(-painter.width / 2, base + 5);
        if (emphasized) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              (offset & painter.size).inflate(3),
              const Radius.circular(4),
            ),
            Paint()..color = DeckColors.background.withValues(alpha: 0.85),
          );
        }
        painter.paint(canvas, offset);
      }
      canvas.restore();
    }
    canvas.restore();
  }

  /// Adds the curved edge to [path]. Returns (endX, endY, tangentX, tangentY).
  (double, double, double, double)? _addCurve(Path path, GraphEdge e) {
    final a = graph.nodes[e.source], b = graph.nodes[e.target];
    final dx = b.x - a.x, dy = b.y - a.y;
    final len = math.max(math.sqrt(dx * dx + dy * dy), 1.0);
    final ux = dx / len, uy = dy / len;
    final sIn = radius(e.source) + 3, eIn = radius(e.target) + 4;
    if (len <= sIn + eIn) return null;
    final sx = a.x + ux * sIn, sy = a.y + uy * sIn;
    final ex = b.x - ux * eIn, ey = b.y - uy * eIn;
    final off = len * 0.07;
    final mx = (sx + ex) / 2 - uy * off, my = (sy + ey) / 2 + ux * off;
    path
      ..moveTo(sx, sy)
      ..quadraticBezierTo(mx, my, ex, ey);
    var tdx = ex - mx, tdy = ey - my;
    final tl = math.max(math.sqrt(tdx * tdx + tdy * tdy), 1e-3);
    tdx /= tl;
    tdy /= tl;
    return (ex, ey, tdx, tdy);
  }

  TextPainter _label(String text, double fs, Color color, bool bold) {
    final key = '$text|$fs|${color.toARGB32()}|$bold';
    final cached = _labelCache[key];
    if (cached != null) return cached;
    if (_labelCache.length > 3000) _labelCache.clear();
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fs, color: color, height: 1.0, fontWeight: bold ? FontWeight.w600 : FontWeight.w400),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    return _labelCache[key] = painter;
  }

  @override
  bool shouldRepaint(covariant _GraphPainter old) =>
      old.tx != tx ||
      old.ty != ty ||
      old.k != k ||
      old.hover != hover ||
      old.sel != sel ||
      old.visible.length != visible.length ||
      old.graph != graph;
}
