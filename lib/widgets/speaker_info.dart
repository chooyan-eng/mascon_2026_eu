import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../theme.dart';

/// Set to true once `assets/speaker.png` is in place (see docs/slides.md).
const showSpeakerImage = false;

/// Speaker info block that works without an image asset.
class SpeakerInfoBlock extends StatelessWidget {
  const SpeakerInfoBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final info = context.flutterDeck.speakerInfo;
    if (info == null) return const SizedBox.shrink();
    if (showSpeakerImage) return FlutterDeckSpeakerInfoWidget(speakerInfo: info);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(info.name, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(info.description, style: const TextStyle(fontSize: 26, color: DeckColors.muted)),
        const SizedBox(height: 6),
        Text(info.socialHandle, style: const TextStyle(fontSize: 26, color: DeckColors.accent)),
      ],
    );
  }
}
