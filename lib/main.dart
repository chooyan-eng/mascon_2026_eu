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
/// with that file. Design language: docs/design_handoff_mascon_deck/README.md.
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
        controls: const FlutterDeckControlsConfiguration(
          gestures: FlutterDeckGesturesConfiguration.mobileOnly(),
        ),
        // Slides draw their own footer (handle + 2-digit page number).
        footer: const FlutterDeckFooterConfiguration(showFooter: false),
        header: const FlutterDeckHeaderConfiguration(showHeader: false),
        marker: const FlutterDeckMarkerConfiguration(
          color: DeckColors.accent,
          strokeWidth: 8,
        ),
        progressIndicator: const FlutterDeckProgressIndicator.solid(
          color: DeckColors.accent,
          backgroundColor: DeckColors.rule,
        ),
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
        description: 'Flutter developer · package author',
        socialHandle: '@tsuyoshi_chujo',
        imagePath: 'assets/me_photo.jpg',
      ),
      slides: const [
        TitleSlide(),
        AboutMeSlide(),
        NumberSlide(),
        DependencyGraphSlide(),
        SupplyChainRiskSlide(),
        ImpactExamplesSlide(),
        RealIncidentSlide(),
        SupplyChainSlide(),
        ExistsVsExecutesSlide(),
        ExecutionSurfacesSlide(),
        DeepDiveIntroSlide(),
        LegitimatePurposeSlide(),
        RealHookCodeSlide(),
        VersionsChangeSlide(),
        PackageUnchangedSlide(),
        ExternalArtifactSlide(),
        WhatBuildConsumesSlide(),
        InspectPackagesSlide(),
        DeepDiveRecapSlide(),
        ZoomOutSlide(),
        EverySurfaceSlide(),
        BeyondDartSlide(),
        SourceVsBinarySlide(),
        MitigationCooldownSlide(),
        MitigationLockfileSlide(),
        NoMagicSlide(),
        AllOfThemSlide(),
        TakeawaysSlide(),
        ThankYouSlide(),
      ],
    );
  }
}
