import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:music_new/services/audio_query_handler.dart';

/// audio state management class
/// contains all audioFiles, currentPlayerAudio, playerState
///
/// func
///   next()
///   previous()
///   playNPause()
///   ...
class PlayerState extends GetxController {
  final audioPlayer = AudioPlayer();
  var playIndex = 0.obs;
  var isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  void playSong(String? uri, index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(uri!)),
      );
      audioPlayer.play();
      isPlaying.value = true;
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
    } else {
      checkPermission();
    }
  }

  Future<List<SongModel>> getDeviceAudios() async {
    return AudioQueryHandler().getDeviceAudios();
  }
}
