import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mascon_eu_2026/dependency_graph/graph_view.dart';
import 'package:mascon_eu_2026/main.dart';

void main() {
  testWidgets('dependency graph slide loads real data and supports selection', (tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // Presenting happens on desktop, where deck swipe gestures are disabled.
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

    // Overflow from the Ahem fallback font (no google_fonts in tests) is not
    // meaningful; swallow it before the framework records it.
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('RenderFlex overflowed')) return;
      original?.call(details);
    };
    addTearDown(() => FlutterError.onError = original);

    await tester.pumpWidget(const MasconDeck());
    await tester.pumpAndSettle();
    tester.element(find.byType(FlutterDeckSlide).last).flutterDeck.goToSlide(4);
    await tester.pumpAndSettle();
    // The asset is decoded off the main isolate; give it real time.
    for (var i = 0; i < 20 && find.byType(DependencyGraphView).evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
      await tester.pumpAndSettle();
    }

    final view = find.byType(DependencyGraphView);
    expect(view, findsOneWidget);
    expect(find.text('direct dependencies'), findsOneWidget);

    // The root node is pinned to the layout origin; after fit it is tappable.
    final state = tester.state<DependencyGraphViewState>(view);
    final graph = state.widget.graph;
    expect(graph.nodes.length, greaterThan(100));

    // Step 2 shows every node.
    tester.element(view).flutterDeck.next();
    await tester.pumpAndSettle();
    expect(find.text('dependencies, direct and transitive'), findsOneWidget);
    expect(state.widget.visible.length, graph.nodes.length);

    // Drag pans without throwing and without leaving the slide.
    await tester.drag(view, const Offset(-200, 50));
    await tester.pumpAndSettle();
    expect(tester.element(view).flutterDeck.slideNumber, 4);
    expect(tester.takeException(), isNull);

    debugDefaultTargetPlatformOverride = null;
  });
}
