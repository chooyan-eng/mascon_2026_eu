import 'dart:async';

import 'package:flutter/material.dart';

import 'markdown_text.dart';
import 'script_parser.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key, required this.slides});

  final List<SlideNote> slides;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _stopwatch = Stopwatch();
  Timer? _ticker;
  final _scrollController = ScrollController();
  final _scrollViewKey = GlobalKey();
  late final List<GlobalKey> _sectionKeys;
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _sectionKeys = List.generate(widget.slides.length, (_) => GlobalKey());
    _ticker = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) {
        if (_stopwatch.isRunning) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      _stopwatch.isRunning ? _stopwatch.stop() : _stopwatch.start();
    });
  }

  Future<void> _resetTimer() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タイマーをリセットしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('リセット'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() {
      _stopwatch.stop();
      _stopwatch.reset();
    });
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.slides.length) return;
    final context = _sectionKeys[index].currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      alignment: 0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  /// The current slide is the last one whose top edge is at or above the
  /// top of the viewport (with a small tolerance).
  void _updateIndexFromScroll() {
    final viewport = _scrollViewKey.currentContext?.findRenderObject();
    if (viewport is! RenderBox) return;
    var current = 0;
    for (var i = 0; i < _sectionKeys.length; i++) {
      final sectionContext = _sectionKeys[i].currentContext;
      final box = sectionContext?.findRenderObject();
      if (box is! RenderBox || !box.attached) continue;
      final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
      if (top <= 24) current = i;
    }
    if (current != _index) setState(() => _index = current);
  }

  Future<void> _showJumpSheet() async {
    final target = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        builder: (context, scrollController) => ListView.builder(
          controller: scrollController,
          itemCount: widget.slides.length,
          itemBuilder: (context, i) {
            final slide = widget.slides[i];
            final selected = i == _index;
            return ListTile(
              selected: selected,
              leading: Text(
                slide.number.toString().padLeft(2, '0'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
              ),
              title: Text(slide.title),
              subtitle: Text(slide.partTitle),
              onTap: () => Navigator.pop(context, i),
            );
          },
        ),
      ),
    );
    if (target != null) _goTo(target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TimerBar(
              elapsed: _stopwatch.elapsed,
              running: _stopwatch.isRunning,
              onToggle: _toggleTimer,
              onReset: _resetTimer,
            ),
            const Divider(height: 1),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification ||
                      notification is ScrollEndNotification) {
                    _updateIndexFromScroll();
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  key: _scrollViewKey,
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < widget.slides.length; i++)
                        _SlideSection(
                          key: _sectionKeys[i],
                          slide: widget.slides[i],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            _NavigationBar(
              index: _index,
              count: widget.slides.length,
              onPrev: () => _goTo(_index - 1),
              onNext: () => _goTo(_index + 1),
              onJump: _showJumpSheet,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  const _TimerBar({
    required this.elapsed,
    required this.running,
    required this.onToggle,
    required this.onReset,
  });

  final Duration elapsed;
  final bool running;
  final VoidCallback onToggle;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            formatDuration(elapsed),
            style: theme.textTheme.displaySmall?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onReset,
            icon: const Icon(Icons.replay),
          ),
          const SizedBox(width: 4),
          IconButton.filled(
            onPressed: onToggle,
            iconSize: 32,
            icon: Icon(running ? Icons.pause : Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}

class _SlideSection extends StatelessWidget {
  const _SlideSection({super.key, required this.slide});

  final SlideNote slide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyStyle = theme.textTheme.bodyLarge!.copyWith(
      fontSize: 20,
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          slide.partTitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${slide.number.toString().padLeft(2, '0')}. ${slide.title}',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        for (final paragraph in slide.paragraphs) ...[
          if (paragraph.isCue)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  paragraph.text,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            )
          else
            MarkdownText(paragraph.text, style: bodyStyle),
          const SizedBox(height: 16),
        ],
        const Divider(height: 32),
      ],
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.index,
    required this.count,
    required this.onPrev,
    required this.onNext,
    required this.onJump,
  });

  final int index;
  final int count;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onJump;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      // 端だと持ち替えないと届かないので、ボタンを内側に寄せる
      padding: const EdgeInsets.symmetric(horizontal: 76, vertical: 8),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: index > 0 ? onPrev : null,
            iconSize: 32,
            icon: const Icon(Icons.keyboard_arrow_up),
          ),
          Expanded(
            child: TextButton(
              onPressed: onJump,
              child: Text(
                '${index + 1} / $count',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          IconButton.filledTonal(
            onPressed: index < count - 1 ? onNext : null,
            iconSize: 32,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }
}
