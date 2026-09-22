import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

/// Picture of a supply chain compromise: one transitive package turns
/// malicious and the compromise travels up the chain to the app.
class SupplyChainRiskSlide extends FlutterDeckSlideWidget {
  const SupplyChainRiskSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/supply-chain-risk',
          title: '05. Supply chain risk',
          steps: 3,
          header: FlutterDeckHeaderConfiguration(title: 'The risk of supply chain attacks'),
          speakerNotes:
              '- Our apps depend on a lot of packages and libraries. That is not bad; it is why we can ship at all.\n'
              '- But on a chain this complex, one compromised package somewhere deep is enough to reach my app.\n'
              '- This is a supply chain attack. The risk keeps growing, and that is what I want to talk about today.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: FlutterDeckSlideStepsBuilder(
          builder: (context, step) => Column(
            children: [
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 48),
                      child: _Tree(
                        step: step,
                        node: const _N('My app', [
                          _N('Package A', [_N('Package D'), _N('Package E')]),
                          _N('Package B'),
                          _N('Package C', [_N.compromised('Package F'), _N('Package G')]),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              const Reveal(
                step: 3,
                child: FooterLine('I never chose Package F. My app ships it anyway.', accent: true),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _N {
  const _N(this.name, [this.children = const []]) : compromised = false;
  const _N.compromised(this.name) : children = const [], compromised = true;

  final String name;
  final List<_N> children;
  final bool compromised;

  /// True when this node or any descendant is the compromised package.
  bool get onPath => compromised || children.any((c) => c.onPath);
}

class _Tree extends StatelessWidget {
  const _Tree({required this.node, required this.step, this.isRoot = true});

  final _N node;
  final int step;
  final bool isRoot;

  @override
  Widget build(BuildContext context) {
    // Step 2: the compromised package turns red. Step 3: the whole path does.
    final red = (node.compromised && step >= 2) || (node.onPath && step >= 3);
    Color line(_N child) => child.onPath && step >= 3 ? DeckColors.danger : DeckColors.muted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Node(node.name, accent: isRoot && !red, danger: red, fontSize: isRoot ? 40 : 32),
            if (node.compromised && step >= 2)
              const Positioned(
                bottom: -40,
                child: Text(
                  'compromised',
                  style: TextStyle(fontSize: 24, color: DeckColors.danger, fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
        if (node.children.isNotEmpty) ...[
          Container(
            width: 3,
            height: 28,
            color: node.children.any((c) => c.onPath) && step >= 3 ? DeckColors.danger : DeckColors.muted,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final child in node.children)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 3, height: 28, color: line(child)),
                      _Tree(node: child, step: step, isRoot: false),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
