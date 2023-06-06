import 'package:get/get.dart';
import 'package:music_new/state/player_state.dart';
import 'package:on_audio_query/on_audio_query.dart';

/// this class handlers querying audio files
///
/// functions
///   getDeviceAudios()
///
/// singleton class - it has single instance
class AudioQueryHandler {
  static AudioQueryHandler? _instance;
  AudioQueryHandler._();

  factory AudioQueryHandler() {
    _instance ??= AudioQueryHandler._();
    return _instance!;
  }
  final audioQuery = OnAudioQuery();

  Future<List<SongModel>> getDeviceAudios() async {
    return audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: null,
      uriType: UriType.EXTERNAL,
    );
  }
}
