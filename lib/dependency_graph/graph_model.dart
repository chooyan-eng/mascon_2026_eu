// Pure Dart (no Flutter imports) so that tool/export_dependency_graph.dart
// can use it with `dart run`.
//
// Ported from ~/development/flutter_projects/dependency_inspector
// (core/lib/src/graph/graph_view_model.dart), reduced to what the slide needs.

/// Node kinds across ecosystems.
enum NodeKind { dartPackage, pod, swiftpmPackage, mavenArtifact, gradlePlugin, bundledBinary }

/// Edge kinds.
enum EdgeKind { dependsOn, vendors, declares }

/// Ecosystem a node belongs to. Decides the layout sector and the color.
enum Ecosystem { dart, ios, android }

class GraphNode {
  GraphNode({required this.kind, required this.name, required this.version, this.x = 0, this.y = 0});

  final NodeKind kind;
  final String name;
  final String version;
  double x;
  double y;
}

class GraphEdge {
  const GraphEdge(this.source, this.target, this.kind);

  final int source;
  final int target;
  final EdgeKind kind;
}

/// Dependency graph with derived lookup structures.
class GraphData {
  GraphData({required this.nodes, required this.edges, required this.rootIndex}) {
    outEdges = List.generate(nodes.length, (_) => <GraphEdge>[]);
    inEdges = List.generate(nodes.length, (_) => <GraphEdge>[]);
    for (final e in edges) {
      outEdges[e.source].add(e);
      inEdges[e.target].add(e);
    }

    // Depth from the root (BFS).
    final d = List<int?>.filled(nodes.length, null);
    d[rootIndex] = 0;
    final queue = [rootIndex];
    while (queue.isNotEmpty) {
      final u = queue.removeAt(0);
      for (final e in outEdges[u]) {
        if (d[e.target] != null) continue;
        d[e.target] = d[u]! + 1;
        queue.add(e.target);
      }
    }
    depth = [for (final v in d) v ?? 1];

    Ecosystem ecoOf(NodeKind kind) => switch (kind) {
      NodeKind.dartPackage || NodeKind.bundledBinary => Ecosystem.dart,
      NodeKind.pod || NodeKind.swiftpmPackage => Ecosystem.ios,
      NodeKind.mavenArtifact || NodeKind.gradlePlugin => Ecosystem.android,
    };
    eco = [for (final n in nodes) ecoOf(n.kind)];
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].kind == NodeKind.bundledBinary && inEdges[i].isNotEmpty) {
        eco[i] = eco[inEdges[i].first.source];
      }
    }

    directSet = {rootIndex, for (final e in outEdges[rootIndex]) e.target};
  }

  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final int rootIndex;

  late final List<List<GraphEdge>> outEdges;
  late final List<List<GraphEdge>> inEdges;
  late final List<int> depth;
  late final List<Ecosystem> eco;

  /// Root + nodes the root depends on directly.
  late final Set<int> directSet;

  bool isDirect(int i) => i != rootIndex && directSet.contains(i);

  int countOf(Ecosystem e) {
    var c = 0;
    for (var i = 0; i < nodes.length; i++) {
      if (i != rootIndex && eco[i] == e) c++;
    }
    return c;
  }

  /// Transitive closure from [id]: dependencies (out) or dependents (in),
  /// restricted to [visible].
  Set<int> closure(int id, {required bool out, required Set<int> visible}) {
    final result = {id};
    final queue = [id];
    while (queue.isNotEmpty) {
      final u = queue.removeAt(0);
      for (final e in (out ? outEdges[u] : inEdges[u])) {
        final v = out ? e.target : e.source;
        if (visible.contains(v) && result.add(v)) queue.add(v);
      }
    }
    return result;
  }

  /// Compact JSON used by the slide asset.
  factory GraphData.fromJson(Map<String, dynamic> json) {
    final nodes = [
      for (final n in json['nodes'] as List)
        GraphNode(
          kind: NodeKind.values.byName((n as Map<String, dynamic>)['k'] as String),
          name: n['n'] as String,
          version: n['v'] as String,
          x: (n['x'] as num?)?.toDouble() ?? 0,
          y: (n['y'] as num?)?.toDouble() ?? 0,
        ),
    ];
    final edges = [
      for (final e in json['edges'] as List)
        GraphEdge((e as List)[0] as int, e[1] as int, EdgeKind.values[e[2] as int]),
    ];
    return GraphData(nodes: nodes, edges: edges, rootIndex: json['root'] as int);
  }

  Map<String, dynamic> toJson() => {
    'root': rootIndex,
    'nodes': [
      for (final n in nodes)
        {
          'k': n.kind.name,
          'n': n.name,
          'v': n.version,
          'x': double.parse(n.x.toStringAsFixed(1)),
          'y': double.parse(n.y.toStringAsFixed(1)),
        },
    ],
    'edges': [
      for (final e in edges) [e.source, e.target, e.kind.index],
    ],
  };
}
