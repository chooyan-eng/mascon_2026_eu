import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import 'slides/slides.dart';
import 'theme.dart';

void main() {
  runApp(const MasconDeck());
}

/// Slide deck for "Security Risks of Packages in Mobile App Development".
///
/// All on-slide text is defined in `docs/slides.md`. Keep this code in sync
/// with that file.
class MasconDeck extends StatelessWidget {
  const MasconDeck({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = buildDeckTheme();
    return FlutterDeckApp(
      configuration: FlutterDeckConfiguration(
        background: const FlutterDeckBackgroundConfiguration(
          light: FlutterDeckBackground.solid(DeckColors.background),
          dark: FlutterDeckBackground.solid(DeckColors.background),
        ),
        // Swipe gestures are limited to mobile so that dragging the interactive
        // dependency graph (slide 04) does not change slides on desktop / web.
        controls: const FlutterDeckControlsConfiguration(gestures: FlutterDeckGesturesConfiguration.mobileOnly()),
        footer: const FlutterDeckFooterConfiguration(showFooter: true, showSlideNumbers: true, showSocialHandle: true),
        header: const FlutterDeckHeaderConfiguration(showHeader: false),
        marker: const FlutterDeckMarkerConfiguration(color: DeckColors.accent, strokeWidth: 8),
        progressIndicator: const FlutterDeckProgressIndicator.solid(color: DeckColors.accent, backgroundColor: DeckColors.surfaceAlt),
        slideSize: FlutterDeckSlideSize.fromAspectRatio(
          aspectRatio: const FlutterDeckAspectRatio.ratio16x9(),
          resolution: const FlutterDeckResolution.fhd(),
        ),
        transition: const FlutterDeckTransition.fade(),
      ),
      lightTheme: theme,
      darkTheme: theme,
      themeMode: ThemeMode.dark,
      speakerInfo: const FlutterDeckSpeakerInfo(
        name: 'Tsuyoshi Chujo',
        description: 'Flutter developer, package author, from Japan',
        socialHandle: '@chooyan_i18n',
        // TODO: place assets/speaker.png, register it in pubspec.yaml, and set
        // `showSpeakerImage` in lib/widgets/speaker_info.dart to true.
        imagePath: 'assets/speaker.png',
      ),
      slides: const [
        TitleSlide(),
        AboutMeSlide(),
        NumberSlide(),
        DependencyGraphSlide(),
        SupplyChainRiskSlide(),
        SupplyChainSlide(),
        RealIncidentSlide(),
        AttackPathASlide(),
        TwoImpactPathsSlide(),
        ExistsVsExecutesSlide(),
        AttackSurfacesSlide(),
        SurfaceTriggersSlide(),
        SourceIntegrityProvenanceSlide(),
        AttackPathToMitigationSlide(),
        DeepDiveIntroSlide(),
        DartHooksSlide(),
        LegitimatePurposeSlide(),
        ExecutionModelSlide(),
        FollowOneHookSlide(),
        DemoSlide(),
        ExternalArtifactSlide(),
        PackageUnchangedSlide(),
        ExistingTrustedPathSlide(),
        BaselineSlide(),
        EverySurfaceSlide(),
        BeyondDartSlide(),
        WhatBuildConsumesSlide(),
        SourceVsBinarySlide(),
        AndroidIosSlide(),
        WhichDependencyGraphSlide(),
        MitigationRevisitedSlide(),
        NoMagicSlide(),
        AssuranceSlide(),
        AllOfThemSlide(),
        AiSlide(),
        TakeawaysSlide(),
        GoOneLevelDeeperSlide(),
        ThankYouSlide(),
      ],
    );
  }
}
