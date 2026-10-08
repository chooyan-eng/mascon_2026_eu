import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Merges the former "attack surfaces" and "surface triggers" slides into
/// one table: mechanism / when it runs / whether you opted in. On click the
/// Build hooks row lights up and the rest sink.
class ExecutionSurfacesSlide extends FlutterDeckSlideWidget {
  const ExecutionSurfacesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/execution-surfaces',
          title: '10. Execution surfaces',
          steps: 2,
          speakerNotes:
              '- Even a single Dart package has several places where its code can run. '
              'What matters for each one: when does it run, and did I opt in?\n'
              '- Runtime code ends up on the end-user device; the others run on my machine or CI.\n'
              '- build_runner is also No: you run the command for one package, but builders from '
              'all packages run together — unlike analyzer plugins (per-package configuration) or '
              'DevTools extensions (explicit enable).\n'
              '- Build hooks are part of the normal build, with no explicit opt-in. '
              'That is the surface we will dig into.',
        ),
      );

  static const _rows = [
    (
      mechanism: 'Library code',
      useMono: false,
      when: 'at runtime',
      optIn: '—',
      detail: 'you call it',
    ),
    (
      mechanism: 'Build hooks / link hooks',
      useMono: false,
      when: 'during the build',
      optIn: 'No',
      detail: 'part of the normal build',
    ),
    (
      mechanism: 'Analyzer plugins',
      useMono: false,
      when: 'during analysis',
      optIn: 'Yes',
      detail: 'explicit configuration',
    ),
    (
      mechanism: 'build_runner / builders',
      useMono: true,
      when: 'during code generation',
      optIn: 'No',
      detail: 'one run executes all builders in the graph',
    ),
    (
      mechanism: 'DevTools extensions',
      useMono: false,
      when: 'while debugging',
      optIn: 'Yes',
      detail: 'user enables it',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Execution surfaces',
        headline: 'When does package code actually run?',
        pageNumber: '10',
        child: Staged(
          step: 2,
          builder: (context, focus) {
            Color rowText(int i) {
              final isHooks = _rows[i].mechanism.startsWith('Build hooks');
              if (!focus) return DeckColors.text;
              return isHooks ? DeckColors.accent : DeckColors.line;
            }

            Color rowDetail(int i) {
              final isHooks = _rows[i].mechanism.startsWith('Build hooks');
              if (!focus) return DeckColors.faint;
              return isHooks ? DeckColors.accent : DeckColors.rule;
            }

            Widget cell(Widget child) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
              child: child,
            );

            return Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: DeckColors.line),
                      ),
                    ),
                    child: Row(
                      children: [
                        for (final (flex, label) in const [
                          (5, 'MECHANISM'),
                          (4, 'WHEN'),
                          (5, 'EXPLICIT OPT-IN?'),
                        ])
                          Expanded(
                            flex: flex,
                            child: cell(
                              Text(
                                label,
                                style: fig(
                                  24,
                                  color: DeckColors.faintest,
                                  letterSpacing: 24 * 0.08,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  for (final (i, row) in _rows.indexed)
                    Enter(
                      delayMs: 250 * i,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: DeckColors.rule),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: cell(
                                AnimatedScale(
                                  scale:
                                      focus &&
                                          row.mechanism.startsWith(
                                            'Build hooks',
                                          )
                                      ? 1.12
                                      : 1,
                                  alignment: Alignment.centerLeft,
                                  duration: const Duration(milliseconds: 700),
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 700),
                                    style: row.useMono
                                        ? mono(30, color: rowText(i))
                                        : fig(36, color: rowText(i)),
                                    child: Text(row.mechanism),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: cell(
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 700),
                                  style: fig(32, color: rowDetail(i)),
                                  child: Text(row.when),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: cell(
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    AnimatedDefaultTextStyle(
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      style: fig(44, color: rowText(i)),
                                      child: Text(row.optIn),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                          milliseconds: 700,
                                        ),
                                        style: fig(26, color: rowDetail(i)),
                                        child: Text(row.detail),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
