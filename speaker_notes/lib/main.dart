import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'notes_screen.dart';
import 'script_parser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final markdown = await rootBundle.loadString('assets/script.md');
  final slides = parseScript(markdown);
  await WakelockPlus.enable();
  runApp(SpeakerNotesApp(slides: slides));
}

class SpeakerNotesApp extends StatelessWidget {
  const SpeakerNotesApp({super.key, required this.slides});

  final List<SlideNote> slides;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speaker Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: NotesScreen(slides: slides),
    );
  }
}
