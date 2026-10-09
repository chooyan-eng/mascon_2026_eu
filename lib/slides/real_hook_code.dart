import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';
import '../widgets/design.dart';
import '../widgets/web_view_dialog.dart';

/// Three cross-fading panels: what real build hooks do, with (dummy) code.
class RealHookCodeSlide extends FlutterDeckSlideWidget {
  const RealHookCodeSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/real-hook-code',
          title: '13. Real hook code',
          steps: 3,
          speakerNotes:
              '- Walk through what real hooks do, one pattern at a time. The code is excerpted '
              'from the real hooks.\n'
              '- powersync downloads its prebuilt SQLite core from GitHub releases and verifies '
              'a SHA-256 digest — a hook doing it right.\n'
              '- objective_c, published by dart.dev, compiles its bundled Objective-C sources '
              'with clang through a child process.\n'
              '- android_libcpp_shared searches the local machine for an installed Android NDK '
              '(env vars, local.properties, common install locations) and bundles its '
              'libc++_shared.so. Completely legitimate — and it shows a hook can read the '
              'developer machine.',
        ),
      );

  // All three panels are real hooks (references in docs/slides.md #13):
  //  1. powersync-ja/powersync.dart packages/powersync/hook/build.dart
  //  2. dart-lang/native pkgs/objective_c/hook/build.dart
  //  3. NexusDynamic/android_libcpp_shared hook/build.dart
  //     (docs/examples/android_libcpp_shared_build_hook.md)
  static const _panels = [
    (
      number: '01 / 03',
      action: 'Download a prebuilt binary',
      detail:
          'powersync downloads its prebuilt SQLite core from GitHub releases '
          'at build time — and verifies a SHA-256 digest',
      meta: 'powersync 2.4.0 ↗',
      url:
          'https://github.com/powersync-ja/powersync.dart/blob/main/packages/powersync/hook/build.dart',
      code:
          '// packages/powersync/hook/build.dart — excerpt\n'
          'final uri = Uri.https(\n'
          "  'github.com',\n"
          "  'powersync-ja/powersync-sqlite-core'\n"
          r"  '/releases/download/$releaseVersion/$fileName',"
          '\n'
          ');\n'
          'final response = «await client.get(uri)»;\n'
          '...',
    ),
    (
      number: '02 / 03',
      action: 'Run a native compiler',
      detail: 'objective_c compiles its bundled Objective-C sources with clang during the build',
      meta: 'objective_c 9.6.0 ↗',
      url:
          'https://github.com/dart-lang/native/blob/main/pkgs/objective_c/hook/build.dart',
      code:
          '// pkgs/objective_c/hook/build.dart — excerpt\n'
          '// (the compiler defaults to clang)\n'
          'Future<void> _compile(\n'
          '    List<String> flags, String output) async {\n'
          r"  final args = [...flags, '-o', output];"
          '\n'
          '  final proc = «await Process.run(_compiler, args)»;\n'
          '  ...\n'
          '}',
    ),
    (
      number: '03 / 03',
      action: 'Search the developer machine',
      detail:
          'android_libcpp_shared discovers a locally installed Android NDK '
          'and bundles its libc++_shared.so — no download, no compile',
      meta: 'android_libcpp_shared 0.3.0 ↗',
      url:
          'https://github.com/NexusDynamic/android_libcpp_shared/blob/main/hook/build.dart',
      code:
          '// hook/build.dart — excerpt\n'
          'final resolution =\n'
          '    «await resolveLibcppShared(input, logger: logger)»;\n'
          '// searches compiler paths, PATH, ANDROID_NDK_HOME,\n'
          '// local.properties, common install locations, ...\n'
          'output.assets.code.add(CodeAsset(\n'
          "  name: 'libc++_shared.so',\n"
          '  file: resolution.libcppShared,\n'
          '  linkMode: DynamicLoadingBundled(),\n'
          '));',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => DesignSlide(
        kicker: 'Build hooks · in the wild',
        headline: 'What real hooks do',
        pageNumber: '13',
        child: FlutterDeckSlideStepsBuilder(
          builder: (context, step) {
            final panel = _panels[(step - 1).clamp(0, _panels.length - 1)];
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.02),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: Padding(
                key: ValueKey(panel.number),
                padding: const EdgeInsets.only(top: 72),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 520,
                      height: 640,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            panel.number,
                            style: mono(24, color: DeckColors.faintest),
                          ),
                          const SizedBox(height: 40),
                          Text(panel.action, style: fig(50, height: 1.1)),
                          const SizedBox(height: 28),
                          Text(
                            panel.detail,
                            style: fig(
                              28,
                              color: DeckColors.faint,
                              height: 1.4,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            panel.meta,
                            style: mono(24, color: DeckColors.faintest),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 64),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'hook/build.dart',
                            style: mono(24, color: DeckColors.faintest),
                          ),
                          const SizedBox(height: 12),
                          MouseRegion(
                            cursor: webViewSupported
                                ? SystemMouseCursors.click
                                : MouseCursor.defer,
                            child: GestureDetector(
                              onTap: webViewSupported
                                  ? () => openWebViewDialog(context, panel.url)
                                  : null,
                              child: SizedBox(
                                width: double.infinity,
                                child: CodeBlock(panel.code),
                              ),
                            ),
                          ),
                          if (webViewSupported) ...[
                            const SizedBox(height: 12),
                            Text(
                              'tap to open on github.com',
                              style: mono(20, color: DeckColors.faintest),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
