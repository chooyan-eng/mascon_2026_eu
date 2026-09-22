import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/deck_widgets.dart';
import '../widgets/reveal.dart';

class AndroidIosSlide extends FlutterDeckSlideWidget {
  const AndroidIosSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/android-ios',
          title: '29. Android / iOS',
          steps: 2,
          speakerNotes:
              '- No deep dive. Both ecosystems have source and binary forms and build-time execution mechanisms.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    const lineStyle = TextStyle(fontSize: 28, height: 1.4);
    return FlutterDeckSlide.split(
      leftBuilder: (context) => Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            BigText('Android', fontSize: 44, accent: true, align: TextAlign.left),
            SizedBox(height: 32),
            ChainColumn(
              items: ['Flutter plugin', 'Gradle dependency', 'JAR / AAR from Maven', 'precompiled artifact'],
              fontSize: 26,
              nodeWidth: 560,
            ),
            SizedBox(height: 32),
            Text(
              'The role matters: implementation dependency, Gradle plugin, KSP / kapt, custom lint',
              style: TextStyle(fontSize: 26, color: DeckColors.muted, height: 1.4),
            ),
          ],
        ),
      ),
      rightBuilder: (context) => Reveal(
        step: 2,
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              BigText('iOS', fontSize: 44, accent: true, align: TextAlign.left),
              SizedBox(height: 32),
              Text('CocoaPods: source_files → compiled by you / vendored_frameworks → precompiled', style: lineStyle),
              SizedBox(height: 24),
              Text('CocoaPods build-time hooks: prepare_command, script_phase', style: lineStyle),
              SizedBox(height: 24),
              Text('SwiftPM: .target → source / .binaryTarget → precompiled / .plugin → tooling', style: lineStyle),
            ],
          ),
        ),
      ),
    );
  }
}
