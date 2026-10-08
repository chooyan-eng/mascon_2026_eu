import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Two topics on one page: audit the hook source (step 1), then notice that
/// the audit is valid for one version only — a new version ships a new hook
/// (step 2). pubspec.lock is reduced to a one-line caution.
class VersionsChangeSlide extends FlutterDeckSlideWidget {
  const VersionsChangeSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/versions-change',
          title: '14. Audit & versions',
          steps: 2,
          speakerNotes:
              '- Bridge to the audit viewpoint: a hook is normal package code, so I can read it — '
              'say I did and it looked fine.\n'
              '- But that check is valid for one version only: a new version can ship or change a '
              'hook, and it runs on the next build. A typical supply chain attack arrives exactly '
              'like this — as a malicious update (callback to 07).\n'
              '- The lockfile decides which version that is. The version you resolved is the version '
              'you build with.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Build hooks · auditing',
        headline: 'Audit the hook — and watch the version',
        pageNumber: '14',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Enter(
              child: _VersionRow(
                label: 'AUDIT',
                version: 'some_package\n1.4.2',
                note: 'read the source · looks fine',
                noteItalic: true,
                gold: false,
              ),
            ),
            const SizedBox(height: 90),
            const Enter(
              step: 2,
              child: _VersionRow(
                label: 'NEW VERSION',
                version: 'some_package\n1.5.0',
                note: 'changed · runs on your next build',
                gold: true,
              ),
            ),
            const SizedBox(height: 84),
            Enter(
              step: 2,
              delayMs: 900,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'pubspec.lock',
                      style: mono(30, color: DeckColors.accent),
                    ),
                    TextSpan(
                      text: ' decides which version your next build runs.',
                      style: fig(30, color: DeckColors.sub),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionRow extends StatelessWidget {
  const _VersionRow({
    required this.label,
    required this.version,
    required this.note,
    required this.gold,
    this.noteItalic = false,
  });

  final String label;
  final String version;
  final String note;
  final bool gold;
  final bool noteItalic;

  @override
  Widget build(BuildContext context) {
    final accent = gold ? DeckColors.accent : null;
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: Text(
            label,
            style: mono(24, color: DeckColors.accent, letterSpacing: 24 * 0.08),
          ),
        ),
        OutlineBox(
          version,
          width: 320,
          height: 140,
          fontSize: 30,
          useMono: true,
          borderColor: accent ?? DeckColors.line,
          textColor: accent ?? DeckColors.faint,
        ),
        const SizedBox(width: 64),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'hook/build.dart',
              style: mono(28, color: accent ?? DeckColors.text),
            ),
            const SizedBox(height: 12),
            Text(
              note,
              style: fig(28, color: DeckColors.faint, italic: noteItalic),
            ),
          ],
        ),
      ],
    );
  }
}
