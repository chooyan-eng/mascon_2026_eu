#!/usr/bin/env python3
"""Removes the Gradle build toolchain from assets/dependency_graph.json.

Drops the gradlePlugin nodes and every Maven artifact that is reachable from
the root only through them (the buildscript classpath: AGP, Kotlin compiler,
lint, etc.), so the deck's numbers describe the dependencies that feed the
app itself rather than the build tooling. Nodes that are unreachable from
the root in the original data (test-only Dart packages) are kept, so the
Dart count is unaffected.

Run after regenerating the graph with tool/export_dependency_graph.dart:

    python3 tool/strip_build_toolchain.py
"""
import collections
import json
import pathlib

PATH = pathlib.Path(__file__).resolve().parent.parent / 'assets/dependency_graph.json'


def main():
    d = json.loads(PATH.read_text())
    nodes, edges, root = d['nodes'], d['edges'], d['root']
    adj = collections.defaultdict(list)
    for a, b, *_ in edges:
        adj[a].append(b)

    def reach(block):
        seen, stack = {root}, [root]
        while stack:
            cur = stack.pop()
            for nxt in adj[cur]:
                if nxt not in block and nxt not in seen:
                    seen.add(nxt)
                    stack.append(nxt)
        return seen

    plugins = {i for i, n in enumerate(nodes) if n['k'] == 'gradlePlugin'}
    if not plugins:
        print('no gradlePlugin nodes — already stripped')
        return
    removed = reach(set()) - reach(plugins)  # plugins + toolchain-only nodes

    remap, new_nodes = {}, []
    for i, n in enumerate(nodes):
        if i in removed:
            continue
        remap[i] = len(new_nodes)
        new_nodes.append(n)
    new_edges = [
        [remap[a], remap[b], *rest]
        for a, b, *rest in edges
        if a not in removed and b not in removed
    ]
    d['nodes'], d['edges'], d['root'] = new_nodes, new_edges, remap[root]
    PATH.write_text(json.dumps(d, separators=(',', ':')))

    kinds = collections.Counter(n['k'] for n in new_nodes)
    total = len(new_nodes) - 1
    print(
        f'removed {len(removed)} nodes; kept {total} (excl. root): '
        f"dart {kinds['dartPackage'] - 1} + maven {kinds['mavenArtifact']} "
        f"+ swiftpm {kinds['swiftpmPackage']}"
    )


main()
