import 'package:flutter/material.dart';
import 'package:music_player/audio_player_provider.dart';
import 'package:provider/provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {

  static const audioSrc = 'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AudioPlayerProvider>(context, listen: false).setUrl(audioSrc);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioPlayerProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 19, 22, 26),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Image.asset('assets/music-note.png', fit: BoxFit.cover,),),
                      const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Sample music file', style: TextStyle(color: Colors.white, fontSize: 16),), 
                        Text(audioPlayerProvider.positionText, style: const TextStyle(color: Colors.white),),
                        ],
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          if (audioPlayerProvider.isPlaying) {
                            audioPlayerProvider.pause();
                          }
                          else {
                            audioPlayerProvider.play();
                          }
                        }, icon: Icon(audioPlayerProvider.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white,))
                  ],
                ),
                const SizedBox(height: 10),
                Slider(
                  onChanged: audioPlayerProvider.onSliderValueChanged,
                  value: audioPlayerProvider.positionInMilli,
                  max: audioPlayerProvider.totalDurationInMilli,
                  thumbColor: Colors.white,
                  activeColor: Colors.white,
                  inactiveColor: const Color(0xff999999),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
