import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Three 2026 package compromise incidents, one per ecosystem.
/// Sources are listed in docs/slides.md #08; the XCSSET case has a full
/// write-up in docs/incidents/xcsset_universal_file_viewer.md.
class RealIncidentSlide extends FlutterDeckSlideWidget {
  const RealIncidentSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/real-incident',
          title: '07. Real-world incidents',
          speakerNotes:
              '- Three incidents in 2026, three ecosystems, three execution mechanisms: '
              'npm preinstall lifecycle script, PyPI package code, and infected Xcode / Gradle '
              'build files inside a Flutter package.\n'
              '- The pattern is always the same: compromised package, normal developer operation, '
              'code execution on dev / CI, credential theft and further compromise.\n'
              '- The third one also shows the reverse direction: a compromised developer machine '
              'entering the supply chain.\n'
              '- The point: this is not an npm-specific problem — it reached our own ecosystem.\n'
              '- No deep low-level knowledge was needed to follow these: the incidents alone show '
              'what was compromised, how the code got executed, and what damage followed.',
        ),
      );

  static const _incidents = [
    (
      tag: 'npm · 2026',
      name: 'Red Hat packages',
      lines: [
        'A malicious preinstall hook was added to legitimate packages',
        'npm install alone executed it on dev machines and CI',
      ],
      link: 'access.redhat.com',
    ),
    (
      tag: 'PyPI · 2026',
      name: 'LiteLLM / Telnyx',
      lines: [
        'Publish credentials compromised; a version with a credential stealer published',
        'Stolen tokens were used to attack further packages',
      ],
      link: 'blog.pypi.org',
    ),
    (
      tag: 'pub.dev · 2026',
      name: 'universal_file_viewer',
      lines: [
        "XCSSET on the maintainer's Mac infected the Android / Xcode projects in example/",
        'Normal commit and publish carried it to GitHub and pub.dev — the package was not the target',
      ],
      link: 'aikido.dev',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Supply chain',
        headline: 'Real-world incidents',
        pageNumber: '07',
        child: Padding(
          padding: const EdgeInsets.only(top: 96),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, incident) in _incidents.indexed) ...[
                if (i > 0) const SizedBox(width: 80),
                Expanded(
                  child: Enter(
                    delayMs: 300 * i,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incident.tag,
                          style: mono(24, color: DeckColors.accent),
                        ),
                        const SizedBox(height: 24),
                        // FittedBox keeps long package names on one line
                        // (universal_file_viewer is wider than the column).
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(incident.name, style: fig(56, height: 1.1)),
                        ),
                        const SizedBox(height: 32),
                        Container(height: 1, color: DeckColors.rule),
                        const SizedBox(height: 32),
                        for (final line in incident.lines)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              line,
                              style: fig(
                                28,
                                color: DeckColors.sub,
                                height: 1.4,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: DeckColors.accentDark),
                            ),
                          ),
                          child: Text(
                            incident.link,
                            style: fig(24, color: DeckColors.accent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
