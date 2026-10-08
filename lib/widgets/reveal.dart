import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

/// Shows [child] once the current slide step is >= [step].
///
/// The child keeps its layout space so that content does not jump.
class Reveal extends StatelessWidget {
  const Reveal({
    required this.step,
    required this.child,
    this.keepSpace = true,
    super.key,
  });

  final int step;
  final Widget child;
  final bool keepSpace;

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlideStepsBuilder(
      builder: (context, current) {
        final visible = current >= step;
        if (!keepSpace && !visible) return const SizedBox.shrink();
        return AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          child: child,
        );
      },
    );
  }
}
