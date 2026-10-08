import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import 'reveal.dart';

/// Horizontal padding used by content areas of blank slides.
const kContentPadding = EdgeInsets.symmetric(horizontal: 96, vertical: 24);

/// A rounded box holding a short label. Used as a node in chain diagrams.
class Node extends StatelessWidget {
  const Node(
    this.text, {
    this.accent = false,
    this.danger = false,
    this.fontSize = 30,
    this.width,
    super.key,
  });

  final String text;
  final bool accent;
  final bool danger;
  final double fontSize;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final bg = danger
        ? DeckColors.danger.withValues(alpha: 0.18)
        : accent
        ? DeckColors.accent.withValues(alpha: 0.18)
        : DeckColors.surface;
    final border = danger
        ? DeckColors.danger
        : accent
        ? DeckColors.accent
        : DeckColors.surfaceAlt;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 2),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          height: 1.25,
          color: DeckColors.onSurface,
        ),
      ),
    );
  }
}

/// Vertical chain of nodes connected by arrows.
///
/// When [stepped] is true, node `i` becomes visible at step `firstStep + i`.
class ChainColumn extends StatelessWidget {
  const ChainColumn({
    required this.items,
    this.stepped = false,
    this.firstStep = 1,
    this.fontSize = 30,
    this.nodeWidth,
    this.dangerIndexes = const {},
    this.accentIndexes = const {},
    this.gap = 6,
    super.key,
  });

  final List<String> items;
  final bool stepped;
  final int firstStep;
  final double fontSize;
  final double? nodeWidth;
  final Set<int> dangerIndexes;
  final Set<int> accentIndexes;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final node = Node(
        items[i],
        fontSize: fontSize,
        width: nodeWidth,
        danger: dangerIndexes.contains(i),
        accent: accentIndexes.contains(i),
      );
      final withArrow = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (i > 0) ...[
            SizedBox(height: gap),
            Icon(
              Icons.arrow_downward_rounded,
              size: fontSize,
              color: DeckColors.muted,
            ),
            SizedBox(height: gap),
          ],
          node,
        ],
      );
      children.add(
        stepped ? Reveal(step: firstStep + i, child: withArrow) : withArrow,
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}

/// Horizontal chain of nodes connected by arrows.
class ChainRow extends StatelessWidget {
  const ChainRow({
    required this.items,
    this.fontSize = 28,
    this.dangerIndexes = const {},
    this.accentIndexes = const {},
    this.separator,
    super.key,
  });

  final List<String> items;
  final double fontSize;
  final Set<int> dangerIndexes;
  final Set<int> accentIndexes;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 16,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            separator ??
                Icon(
                  Icons.arrow_forward_rounded,
                  size: fontSize,
                  color: DeckColors.muted,
                ),
          Node(
            items[i],
            fontSize: fontSize,
            danger: dangerIndexes.contains(i),
            accent: accentIndexes.contains(i),
          ),
        ],
      ],
    );
  }
}

/// Large centered statement text.
class BigText extends StatelessWidget {
  const BigText(
    this.text, {
    this.fontSize = 64,
    this.accent = false,
    this.muted = false,
    this.strike = false,
    this.align = TextAlign.center,
    super.key,
  });

  final String text;
  final double fontSize;
  final bool accent;
  final bool muted;
  final bool strike;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: accent
            ? DeckColors.accent
            : muted
            ? DeckColors.muted
            : DeckColors.onSurface,
        decoration: strike ? TextDecoration.lineThrough : null,
        decorationColor: DeckColors.danger,
        decorationThickness: 3,
      ),
    );
  }
}

/// Small label chip.
class Tag extends StatelessWidget {
  const Tag(this.text, {this.accent = false, super.key});

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: accent ? DeckColors.accent : DeckColors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: accent ? DeckColors.onAccent : DeckColors.muted,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

/// A card with a title and a list of lines.
class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.title,
    this.lines = const [],
    this.accent = false,
    this.fontSize = 26,
    super.key,
  });

  final String title;
  final List<String> lines;
  final bool accent;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: DeckColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accent ? DeckColors.accent : DeckColors.surfaceAlt,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize + 8,
              fontWeight: FontWeight.w700,
              color: accent ? DeckColors.accent : DeckColors.onSurface,
            ),
          ),
          if (lines.isNotEmpty) const SizedBox(height: 16),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                line,
                style: TextStyle(
                  fontSize: fontSize,
                  height: 1.3,
                  color: DeckColors.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Simple table with optional per-row step reveal.
class DeckTable extends StatelessWidget {
  const DeckTable({
    required this.columns,
    required this.rows,
    this.stepped = false,
    this.firstStep = 1,
    this.fontSize = 26,
    this.columnWidths,
    this.rowSteps,
    this.accentRows = const {},
    super.key,
  });

  /// Step at which each row appears. Overrides [stepped] / [firstStep].
  final List<int>? rowSteps;

  /// Rows whose first cell is drawn in the accent color.
  final Set<int> accentRows;

  final List<String> columns;
  final List<List<String>> rows;
  final bool stepped;
  final int firstStep;
  final double fontSize;
  final Map<int, TableColumnWidth>? columnWidths;

  @override
  Widget build(BuildContext context) {
    Widget cell(String text, {bool header = false, bool accent = false}) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(
            text,
            style: TextStyle(
              fontSize: header ? fontSize - 2 : fontSize,
              fontWeight: header ? FontWeight.w700 : FontWeight.w400,
              color: header
                  ? DeckColors.muted
                  : accent
                  ? DeckColors.accent
                  : DeckColors.onSurface,
              height: 1.3,
            ),
          ),
        );

    return Table(
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder(
        horizontalInside: BorderSide(color: DeckColors.surfaceAlt, width: 1.5),
        bottom: BorderSide(color: DeckColors.surfaceAlt, width: 1.5),
      ),
      children: [
        TableRow(children: [for (final c in columns) cell(c, header: true)]),
        for (var i = 0; i < rows.length; i++)
          TableRow(
            children: [
              for (final (j, c) in rows[i].indexed)
                if (rowSteps != null)
                  Reveal(
                    step: rowSteps![i],
                    child: cell(c, accent: j == 0 && accentRows.contains(i)),
                  )
                else if (stepped)
                  Reveal(step: firstStep + i, child: cell(c))
                else
                  cell(c, accent: j == 0 && accentRows.contains(i)),
            ],
          ),
      ],
    );
  }
}

/// A short muted line placed at the bottom of a slide's content area.
class FooterLine extends StatelessWidget {
  const FooterLine(this.text, {this.accent = false, super.key});

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontStyle: FontStyle.italic,
        color: accent ? DeckColors.accent : DeckColors.muted,
        height: 1.3,
      ),
    );
  }
}

/// Bullet list built from plain text with the deck's bullet theme.
class Bullets extends StatelessWidget {
  const Bullets(
    this.items, {
    this.useSteps = false,
    this.stepOffset = 0,
    super.key,
  });

  final List<String> items;
  final bool useSteps;
  final int stepOffset;

  @override
  Widget build(BuildContext context) {
    return FlutterDeckBulletList(
      items: items,
      useSteps: useSteps,
      stepOffset: stepOffset,
      bulletPointWidget: const Padding(
        padding: EdgeInsets.only(top: 18),
        child: Icon(Icons.circle, size: 14, color: DeckColors.accent),
      ),
    );
  }
}

/// Standard content wrapper for blank slides: padding + optional bottom line.
class SlideBody extends StatelessWidget {
  const SlideBody({
    required this.child,
    this.footerLine,
    this.footerAccent = false,
    super.key,
  });

  final Widget child;
  final String? footerLine;
  final bool footerAccent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: child),
          if (footerLine != null) ...[
            const SizedBox(height: 16),
            FooterLine(footerLine!, accent: footerAccent),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
