import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../theme.dart';

/// WebView is available on these platforms only (no web / Windows support).
bool get webViewSupported =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

/// Shows [url] in a modal WebView over the slide.
void openWebViewDialog(BuildContext context, String url) {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(url));
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'source',
    barrierColor: const Color(0xCC000000),
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
    pageBuilder: (dialogContext, _, _) => Center(
      child: FractionallySizedBox(
        widthFactor: 0.85,
        heightFactor: 0.88,
        child: Container(
          decoration: BoxDecoration(
            color: DeckColors.background,
            border: Border.all(color: DeckColors.accent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: WebViewWidget(controller: controller),
          ),
        ),
      ),
    ),
  );
}
