import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class PackageUnchangedSlide extends FlutterDeckSlideWidget {
  const PackageUnchangedSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/package-unchanged',
          title: '22. The package didn\'t change',
          steps: 3,
          header: FlutterDeckHeaderConfiguration(title: "Attack path B: the package didn't change"),
          speakerNotes: '- Key finding. The build input changed; the package did not.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Reveal(
              step: 1,
              child: _Row(label: 'Yesterday', items: ['Same package', 'Same hook', 'Good artifact']),
            ),
            const SizedBox(height: 40),
            const Reveal(
              step: 2,
              child: _Row(label: 'Today', items: ['Same package', 'Same hook', 'Malicious artifact'], danger: true),
            ),
            const SizedBox(height: 24),
            const Reveal(step: 2, child: FooterLine('Same version. Same source. Same pub content hash.')),
            const SizedBox(height: 64),
            const Reveal(
              step: 3,
              child: BigText('Can this dependency change its behavior without changing itself?', fontSize: 48, accent: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.items, this.danger = false});

  final String label;
  final List<String> items;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 220,
          child: Text(label, style: const TextStyle(fontSize: 34, color: DeckColors.muted, fontWeight: FontWeight.w600)),
        ),
        Flexible(child: ChainRow(items: items, fontSize: 32, dangerIndexes: danger ? const {2} : const {})),
      ],
    );
  }
}
