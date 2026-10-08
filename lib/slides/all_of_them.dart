import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../dependency_graph/graph_model.dart';
import '../dependency_graph/graph_view.dart';
import '../theme.dart';
import '../widgets/design.dart';

/// 606 again: can we do this for every dependency? Honest answer: no.
/// The dependency graph from slide 04 sits ghosted in the background.
class AllOfThemSlide extends FlutterDeckSlideWidget {
  const AllOfThemSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/all-of-them',
          title: '27. 606 again',
          steps: 2,
          speakerNotes:
              '- Honest answer: no. Prioritize high-risk mechanisms, enumerate surfaces mechanically, '
              'classify source / binary / download, keep the risk decision human.\n'
              '- AI is an investigation amplifier, not a security decision maker: it makes going one '
              'level deeper much cheaper, but the questions — and the risk decision — are still yours.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        pageNumber: '27',
        child: Stack(
          children: [
            const Positioned.fill(child: _GraphBackdrop()),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Enter(
                    child: Text(
                      '606',
                      style: fig(
                        252,
                        color: DeckColors.accent,
                        height: 0.9,
                        letterSpacing: -0.02 * 252,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Enter(
                    delayMs: 300,
                    child: Text(
                      'Can we do this for all 606 dependencies?',
                      style: fig(45),
                    ),
                  ),
                  const SizedBox(height: 56),
                  Enter(
                    step: 2,
                    child: Text(
                      'No. Understand the mechanisms, then prioritize.',
                      style: fig(48, color: DeckColors.sub),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Enter(
                    step: 2,
                    delayMs: 500,
                    child: Text(
                      'AI makes going one level deeper much cheaper — the questions are still yours.',
                      style: fig(30, color: DeckColors.faint, italic: true),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The real dependency graph (same data as slide 04), non-interactive and
/// ghosted so it does not compete with the text.
class _GraphBackdrop extends StatefulWidget {
  const _GraphBackdrop();

  @override
  State<_GraphBackdrop> createState() => _GraphBackdropState();
}

class _GraphBackdropState extends State<_GraphBackdrop> {
  static GraphData? _cache;

  late final Future<GraphData> _graph = _cache != null
      ? Future.value(_cache)
      : rootBundle
            .loadString('assets/dependency_graph.json')
            .then(
              (s) => _cache = GraphData.fromJson(
                jsonDecode(s) as Map<String, dynamic>,
              ),
            );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GraphData>(
      future: _graph,
      builder: (context, snapshot) {
        final graph = snapshot.data;
        if (graph == null) return const SizedBox.shrink();
        return IgnorePointer(
          child: Opacity(
            opacity: 0.3,
            child: DependencyGraphView(
              graph: graph,
              visible: {for (var i = 0; i < graph.nodes.length; i++) i},
            ),
          ),
        );
      },
    );
  }
}
