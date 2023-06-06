import 'package:just_audio/just_audio.dart';

/// it plays audio given audio source

class AudioPlayerHandler {
  static AudioPlayerHandler? _instance;
  AudioPlayerHandler._();

  factory AudioPlayerHandler() {
    _instance ??= AudioPlayerHandler._();
    return _instance!;
  }

  final audioPlayer = AudioPlayer();


}
