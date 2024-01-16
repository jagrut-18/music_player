import 'package:flutter/material.dart';
import 'package:music_player/audio_player_provider.dart';
import 'package:music_player/audio_player_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
        ChangeNotifierProvider(
          create: (_) => AudioPlayerProvider(),
        ),
      ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AudioPlayerWidget(),
        ),
      ),
    );
  }
}
