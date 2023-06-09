import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// it plays audio given audio source

class AudioPlayerHandler {
  static AudioPlayerHandler? _instance;
  AudioPlayerHandler._() {
    _init();
  }

  factory AudioPlayerHandler() {
    _instance ??= AudioPlayerHandler._();
    return _instance!;
  }

  final _audioPlayer = AudioPlayer();
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  void dispose() {
    _audioPlayer.dispose();
  }

  void _init() {}
  void pause() {}
  void play() {}
  void updatePosition(double pos) {}
}
