/// Parses the talk script (assets/script.md, the single source of truth)
/// into slide notes.
///
/// Only the confirmed part of the script is used:
/// - Sections `### NN. Title — M:SS` under `## Part N — ...` headings.
/// - Parsing stops at the `## 退避` section (old scripts for hidden pages).
/// - Standalone `[VERIFY: ...]` / `[TODO ...]` lines are dropped as
///   unconfirmed content.
library;

/// One paragraph of a slide's note.
class NoteParagraph {
  const NoteParagraph(this.text, {this.isCue = false});

  /// Raw markdown text (inline `**bold**` and `` `code` `` preserved).
  final String text;

  /// True for `[→ step N]` lines — operation cues, not spoken text.
  final bool isCue;
}

class SlideNote {
  const SlideNote({
    required this.number,
    required this.title,
    required this.partTitle,
    required this.duration,
    required this.plannedStart,
    required this.paragraphs,
  });

  final int number;
  final String title;
  final String partTitle;

  /// Planned duration of this slide. Zero when the heading has none.
  final Duration duration;

  /// Planned elapsed time at the moment this slide starts.
  final Duration plannedStart;

  final List<NoteParagraph> paragraphs;
}

final _partPattern = RegExp(r'^## (Part \d+.*)$');
final _slidePattern = RegExp(r'^### (\d+)\.\s*(.+?)(?:\s*—\s*(\d+):(\d+))?$');
final _unconfirmedPattern = RegExp(r'^\[(VERIFY|TODO)');

List<SlideNote> parseScript(String markdown) {
  final slides = <SlideNote>[];
  var partTitle = '';
  var plannedStart = Duration.zero;

  int? number;
  String? title;
  var duration = Duration.zero;
  var paragraphs = <NoteParagraph>[];
  var buffer = <String>[];

  void flushParagraph() {
    if (buffer.isEmpty) return;
    final text = buffer.join(' ').trim();
    buffer = [];
    if (text.isEmpty) return;
    paragraphs.add(NoteParagraph(text, isCue: text.startsWith('[→')));
  }

  void flushSlide() {
    flushParagraph();
    if (number == null) return;
    slides.add(SlideNote(
      number: number!,
      title: title!,
      partTitle: partTitle,
      duration: duration,
      plannedStart: plannedStart,
      paragraphs: paragraphs,
    ));
    plannedStart += duration;
    number = null;
    title = null;
    duration = Duration.zero;
    paragraphs = [];
  }

  for (final rawLine in markdown.split('\n')) {
    final line = rawLine.trimRight();

    if (line.startsWith('## 退避')) break;

    final partMatch = _partPattern.firstMatch(line);
    if (partMatch != null) {
      flushSlide();
      partTitle = partMatch.group(1)!;
      continue;
    }

    final slideMatch = _slidePattern.firstMatch(line);
    if (slideMatch != null) {
      flushSlide();
      number = int.parse(slideMatch.group(1)!);
      title = slideMatch.group(2)!;
      duration = slideMatch.group(3) == null
          ? Duration.zero
          : Duration(
              minutes: int.parse(slideMatch.group(3)!),
              seconds: int.parse(slideMatch.group(4)!),
            );
      continue;
    }

    // Ignore everything before the first slide heading, and structural lines.
    if (number == null) continue;
    if (line.startsWith('#') || line == '---') {
      flushParagraph();
      continue;
    }

    if (line.trim().isEmpty) {
      flushParagraph();
      continue;
    }
    if (_unconfirmedPattern.hasMatch(line.trim())) continue;
    // Cue lines form their own paragraph even without surrounding blanks.
    if (line.trim().startsWith('[→')) {
      flushParagraph();
      paragraphs.add(NoteParagraph(line.trim(), isCue: true));
      continue;
    }
    buffer.add(line.trim());
  }
  flushSlide();
  return slides;
}

String formatDuration(Duration d) {
  final sign = d.isNegative ? '-' : '';
  final abs = d.abs();
  final m = abs.inMinutes;
  final s = abs.inSeconds % 60;
  return '$sign$m:${s.toString().padLeft(2, '0')}';
}
