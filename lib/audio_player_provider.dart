import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class AudioPlayerProvider with ChangeNotifier {
  late AudioPlayer _player;

  // subscriptions
  Duration? _currentDuration;
  StreamSubscription? _durationSubscription;
  Duration? _currentPosition;
  StreamSubscription? _positionSubscription;

  // constructor
  AudioPlayerProvider() {
    _player = AudioPlayer();
    _durationSubscription = _player.durationStream.listen((duration) {
      _currentDuration = duration;
      notifyListeners();
    });
    _positionSubscription = _player.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });
  }

  // getters
  String get durationText => _currentDuration?.toString().split('.').first ?? '';
  String get positionText => _currentPosition?.toString().split('.').first ?? '';

  double get totalDurationInMilli => _currentDuration?.inMilliseconds.toDouble() ?? 0;
  double get positionInMilli => _currentPosition?.inMilliseconds.toDouble() ?? 0;

  bool get isPlaying => _player.playing;

  // methods

  void setUrl(String audioSrc) async {
    await _player.setUrl(audioSrc);
  }

  void play() {
    _player.play();
    notifyListeners();
  }

  void pause() {
    _player.pause();
    notifyListeners();
  }

  void onSliderValueChanged(double value) {
    _player.seek(Duration(milliseconds: value.round()));
  }

  void stop() {
    _player.stop();
    notifyListeners();
  }

  // lifecyle methods

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }
}