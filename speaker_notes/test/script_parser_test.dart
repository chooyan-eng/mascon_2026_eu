import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speaker_notes/notes_screen.dart';
import 'package:speaker_notes/script_parser.dart';

void main() {
  final markdown = File('assets/script.md').readAsStringSync();

  group('parseScript', () {
    test('parses all confirmed slides and nothing from 退避', () {
      final slides = parseScript(markdown);
      expect(slides, hasLength(30));
      expect(slides.first.number, 1);
      expect(slides.first.title, 'Title');
      expect(slides.last.number, 30);
      expect(slides.last.title, 'Thank you');
      // 旧 08. Attack path A lives in the 退避 section and must be excluded.
      expect(slides.any((s) => s.title.contains('Attack path A')), isFalse);
    });

    test('drops [VERIFY] lines but keeps cues', () {
      final slides = parseScript(markdown);
      final trustBoundary = slides.singleWhere((s) => s.number == 16);
      expect(
        trustBoundary.paragraphs.any((p) => p.text.contains('[VERIFY')),
        isFalse,
      );
      expect(trustBoundary.paragraphs.any((p) => p.isCue), isTrue);
    });

    test('computes durations and planned start times', () {
      final slides = parseScript(markdown);
      expect(slides.first.duration, const Duration(seconds: 20));
      expect(slides.first.plannedStart, Duration.zero);
      expect(slides[1].plannedStart, const Duration(seconds: 20));
      // 29. GitHub has no duration in the heading.
      final github = slides.singleWhere((s) => s.number == 29);
      expect(github.duration, Duration.zero);
    });
  });

  test('formatDuration', () {
    expect(formatDuration(const Duration(seconds: 80)), '1:20');
    expect(formatDuration(const Duration(seconds: -5)), '-0:05');
  });

  testWidgets('NotesScreen renders, navigates and jumps', (tester) async {
    final slides = parseScript(markdown);
    await tester.pumpWidget(MaterialApp(home: NotesScreen(slides: slides)));

    expect(find.textContaining('01. Title'), findsOneWidget);
    expect(find.text('1 / 30'), findsOneWidget);

    // Down button scrolls so that the next slide heading reaches the top.
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
    expect(find.text('2 / 30'), findsOneWidget);

    // Up button returns to the previous slide.
    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.pumpAndSettle();
    expect(find.text('1 / 30'), findsOneWidget);

    // Jump sheet
    await tester.tap(find.text('1 / 30'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('458'));
    await tester.pumpAndSettle();
    expect(find.text('3 / 30'), findsOneWidget);
  });
}
