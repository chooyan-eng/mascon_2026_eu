// Converts a dependency_inspector snapshot into the compact asset used by
// slide 04 (assets/dependency_graph.json).
//
// Only node kind / name / version and edges are kept. Local paths, git
// commits, hashes and findings in the snapshot are dropped on purpose.
//
// Usage:
//   dart run tool/export_dependency_graph.dart <snapshot.json> [--root-label "My app"]
import 'dart:convert';
import 'dart:io';

import 'package:mascon_eu_2026/dependency_graph/graph_layout.dart';
import 'package:mascon_eu_2026/dependency_graph/graph_model.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('usage: dart run tool/export_dependency_graph.dart <snapshot.json> [--root-label <label>]');
    exit(64);
  }
  final labelIndex = args.indexOf('--root-label');
  final rootLabel = labelIndex >= 0 && labelIndex + 1 < args.length ? args[labelIndex + 1] : null;

  final snapshot = jsonDecode(File(args.first).readAsStringSync()) as Map<String, dynamic>;
  final targetName = (snapshot['target'] as Map<String, dynamic>)['name'] as String;
  final rawNodes = (snapshot['nodes'] as List).cast<Map<String, dynamic>>();

  final indexById = <String, int>{};
  final nodes = <GraphNode>[];
  var root = 0;
  for (final n in rawNodes) {
    final kind = NodeKind.values.byName(n['kind'] as String);
    final name = n['name'] as String;
    final isRoot = kind == NodeKind.dartPackage && name == targetName;
    if (isRoot) root = nodes.length;
    indexById[n['id'] as String] = nodes.length;
    nodes.add(GraphNode(
      kind: kind,
      name: isRoot && rootLabel != null ? rootLabel : name,
      version: isRoot && rootLabel != null ? '' : n['version'] as String,
    ));
  }

  final seen = <String>{};
  final edges = <GraphEdge>[];
  for (final e in (snapshot['edges'] as List).cast<Map<String, dynamic>>()) {
    final s = indexById[e['from']], t = indexById[e['to']];
    if (s == null || t == null || s == t) continue;
    final kind = EdgeKind.values.byName(e['kind'] as String);
    if (seen.add('$s>$t>${kind.name}')) edges.add(GraphEdge(s, t, kind));
  }

  final graph = GraphData(nodes: nodes, edges: edges, rootIndex: root);
  computeLayout(graph);

  final out = File('assets/dependency_graph.json')
    ..createSync(recursive: true)
    ..writeAsStringSync(jsonEncode(graph.toJson()));
  stdout.writeln('wrote ${out.path}: ${nodes.length} nodes, ${edges.length} edges, '
      'direct=${graph.directSet.length - 1}, '
      'dart=${graph.countOf(Ecosystem.dart)}, ios=${graph.countOf(Ecosystem.ios)}, '
      'android=${graph.countOf(Ecosystem.android)}');
}
