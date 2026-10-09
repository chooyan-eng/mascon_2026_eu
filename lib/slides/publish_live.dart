import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../theme.dart';
import '../widgets/design.dart';

/// Live demo: publish this very deck to GitHub Pages by running the
/// "Deploy to GitHub Pages" workflow from an embedded, pre-logged-in WebView.
class PublishLiveSlide extends FlutterDeckSlideWidget {
  const PublishLiveSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/publish-live',
          title: '29. Publish this deck',
          speakerNotes:
              '- This deck is a Flutter app, so it also builds for the web.\n'
              '- Run the "Deploy to GitHub Pages" workflow live (Run workflow).\n'
              '- It will appear at chooyan-eng.github.io/mascon_2026_eu in a '
              'few minutes — no need to wait on stage.',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const DesignSlide(
        pageNumber: '29',
        child: _GitHubActionsView(),
      ),
    );
  }
}

/// Embedded browser opened on the deploy workflow page. The GitHub session
/// lives in WKWebView's default (persistent) data store, so logging in once
/// during rehearsal keeps the session across app restarts.
class _GitHubActionsView extends StatefulWidget {
  const _GitHubActionsView();

  static const workflowUrl =
      'https://github.com/chooyan-eng/mascon_2026_eu/actions/workflows/deploy.yml';

  @override
  State<_GitHubActionsView> createState() => _GitHubActionsViewState();
}

class _GitHubActionsViewState extends State<_GitHubActionsView>
    with WidgetsBindingObserver {
  // Null when no platform implementation is registered (widget tests).
  WebViewController? _controller;
  OverlayEntry? _overlay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (WebViewPlatform.instance != null) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(_GitHubActionsView.workflowUrl));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // The WebView must live outside flutter_deck's FittedBox: WKWebView
        // is a native view and its mouse hit testing ignores the slide's
        // scale transform, so clicks land offset. The root overlay is not
        // scaled; this widget only reserves the area on the slide.
        _overlay = OverlayEntry(builder: _buildOverlay);
        Overlay.of(context, rootOverlay: true).insert(_overlay!);
      });
    }
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlay?.markNeedsBuild();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _overlay?.remove();
    _overlay?.dispose();
    _overlay = null;
    super.dispose();
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) {
      return const SizedBox.shrink();
    }
    // localToGlobal goes through the FittedBox transform, so this is the
    // placeholder's on-screen rect in (unscaled) window coordinates.
    final rect = Rect.fromPoints(
      box.localToGlobal(Offset.zero),
      box.localToGlobal(box.size.bottomRight(Offset.zero)),
    );
    return Positioned.fromRect(
      rect: rect,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: DeckColors.line)),
        child: WebViewWidget(controller: _controller!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: DeckColors.line)),
        child: Center(
          child: Text(
            _GitHubActionsView.workflowUrl,
            style: fig(28, color: DeckColors.faint),
          ),
        ),
      );
    }
    return const SizedBox.expand();
  }
}
