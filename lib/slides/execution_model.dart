import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/deck_widgets.dart';

class ExecutionModelSlide extends FlutterDeckSlideWidget {
  const ExecutionModelSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/execution-model',
          title: '18. Execution model',
          header: FlutterDeckHeaderConfiguration(title: 'A hook is a Dart program. What do I need to know?'),
          speakerNotes:
              '- Not unlimited arbitrary execution; there are constraints.\n'
              '- But calling native tools is legitimate, so it is a developer / CI execution surface.\n'
              '- [NEEDS VERIFICATION] trigger, transitive hooks, working dir, env, fs / network, child process inheritance.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO(verify): replace the footer line with measured results (docs/slides.md #18).
    const questions = [
      'When does it fire?',
      'Direct vs transitive packages?',
      'Working directory?',
      'Visible environment variables?',
      'Filesystem access?',
      'Network access?',
      'Can it start a child process?',
      'What does the child process inherit?',
    ];
    return FlutterDeckSlide.blank(
      builder: (context) => SlideBody(
        footerLine: '[NEEDS VERIFICATION] To be confirmed against official docs, SDK source and a PoC.',
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 5.2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 24,
            physics: const NeverScrollableScrollPhysics(),
            children: [for (final q in questions) Node(q, fontSize: 32)],
          ),
        ),
      ),
    );
  }
}
