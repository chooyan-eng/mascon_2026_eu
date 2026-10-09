import 'package:flutter/material.dart';

/// Renders a single paragraph of script text, honoring inline markdown
/// emphasis: `**bold**` and `` `code` ``.
class MarkdownText extends StatelessWidget {
  const MarkdownText(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  static final _inlinePattern = RegExp(r'\*\*(.+?)\*\*|`([^`]+)`');

  @override
  Widget build(BuildContext context) {
    final emphasisColor = Theme.of(context).colorScheme.primary;
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final match in _inlinePattern.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      final bold = match.group(1);
      if (bold != null) {
        spans.add(TextSpan(
          text: bold,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: emphasisColor,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: match.group(2),
          style: const TextStyle(fontFamily: 'monospace'),
        ));
      }
      cursor = match.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return Text.rich(TextSpan(style: style, children: spans));
  }
}
