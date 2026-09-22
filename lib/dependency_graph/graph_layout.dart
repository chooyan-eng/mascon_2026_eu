// Pure Dart. Ported from dependency_inspector core/lib/src/graph/layout.dart.
import 'dart:math' as math;

import 'graph_model.dart';

/// Angular sector (rad) per ecosystem.
const _sectors = {
  Ecosystem.dart: (-2.85, 0.55),
  Ecosystem.ios: (0.55, 1.95),
  Ecosystem.android: (1.95, 3.43),
};

const _ringGap = 95.0;

/// Deterministic LCG so the layout is reproducible.
class _Lcg {
  int _s = 7;

  double next() {
    _s = (_s * 1664525 + 1013904223) & 0xFFFFFFFF;
    return _s / 4294967296;
  }
}

/// Sector x concentric-ring initial placement, then a force model
/// (repulsion / springs / ring attraction / sector pull-back).
/// Writes the result into `graph.nodes[i].x / y`. The root stays at origin.
void computeLayout(GraphData graph, {int iterations = 150}) {
  final rand = _Lcg();
  final n = graph.nodes.length;
  final px = List<double>.filled(n, 0);
  final py = List<double>.filled(n, 0);

  final count = <String, int>{};
  for (var i = 0; i < n; i++) {
    if (i == graph.rootIndex) continue;
    final key = '${graph.eco[i].name}${graph.depth[i]}';
    count[key] = (count[key] ?? 0) + 1;
  }
  final index = <String, int>{};
  for (var i = 0; i < n; i++) {
    if (i == graph.rootIndex) continue;
    final d = graph.depth[i];
    final key = '${graph.eco[i].name}$d';
    final ith = (index[key] = (index[key] ?? 0) + 1);
    final m = count[key]! + 1;
    final (w0, w1) = _sectors[graph.eco[i]]!;
    final a = w0 + (w1 - w0) * (ith / m) + (rand.next() - 0.5) * 0.06;
    final r = _ringGap * d + (rand.next() * 30 - 15);
    px[i] = math.cos(a) * r;
    py[i] = math.sin(a) * r;
  }

  for (var it = 0; it < iterations; it++) {
    final step = 0.8 * (1 - it / iterations) + 0.05;

    // Repulsion (200px cutoff).
    for (var i = 0; i < n; i++) {
      for (var j = i + 1; j < n; j++) {
        var dx = px[j] - px[i];
        var dy = py[j] - py[i];
        final d2 = dx * dx + dy * dy + 0.01;
        if (d2 > 40000) continue;
        final f = 1300 / d2;
        dx *= f;
        dy *= f;
        px[i] -= dx * step;
        py[i] -= dy * step;
        px[j] += dx * step;
        py[j] += dy * step;
      }
    }

    // Springs (natural length 80).
    for (final e in graph.edges) {
      final dx = px[e.target] - px[e.source], dy = py[e.target] - py[e.source];
      final d = math.sqrt(dx * dx + dy * dy);
      final dd = d == 0 ? 1.0 : d;
      final f = (dd - 80) * 0.018 * step / dd;
      px[e.source] += dx * f;
      py[e.source] += dy * f;
      px[e.target] -= dx * f;
      py[e.target] -= dy * f;
    }

    // Ring attraction + sector pull-back. Root is pinned to the origin.
    for (var i = 0; i < n; i++) {
      if (i == graph.rootIndex) {
        px[i] = 0;
        py[i] = 0;
        continue;
      }
      final d = graph.depth[i] == 0 ? 1 : graph.depth[i];
      var r = math.sqrt(px[i] * px[i] + py[i] * py[i]);
      if (r == 0) r = 1;
      final f = (_ringGap * d - r) * 0.06 * step / r;
      px[i] += px[i] * f;
      py[i] += py[i] * f;

      final (w0, w1) = _sectors[graph.eco[i]]!;
      var a = math.atan2(py[i], px[i]);
      while (a < w0) {
        a += math.pi * 2;
      }
      if (a > w1) {
        final goal = (a - w1) < (w0 + math.pi * 2 - a) ? w1 : w0;
        final na = a + (goal - a) * 0.15 * step;
        final rr = math.sqrt(px[i] * px[i] + py[i] * py[i]);
        px[i] = math.cos(na) * rr;
        py[i] = math.sin(na) * rr;
      }
    }
  }

  for (var i = 0; i < n; i++) {
    graph.nodes[i]
      ..x = px[i]
      ..y = py[i];
  }
}
