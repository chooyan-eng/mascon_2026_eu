import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class SupplyChainSlide extends FlutterDeckSlideWidget {
  const SupplyChainSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/supply-chain',
          title: '06. Software supply chain',
          steps: 2,
          header: FlutterDeckHeaderConfiguration(title: 'Software supply chain is more than packages'),
          speakerNotes:
              '- By the way, a supply chain is more than packages: CI, IDE extensions, build tools and so on.\n'
              '- Today I focus on packages and libraries.\n'
              "- Now let's look at what a real compromise looks like.",
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    Node('Compiler'),
                    Node('Build tool'),
                    Node('CI'),
                    Node('IDE extension'),
                    Node('Package registry'),
                    Node('Container image'),
                    Node('Binary artifact'),
                    Node('External build tool'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 64),
            const Expanded(
              child: Reveal(
                step: 2,
                child: BigText('Today, I mainly focus on packages and libraries.', fontSize: 56, accent: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
