import 'dart:async';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:music_new/services/audio_query_handler.dart';

/// audio state management class
/// contains all audioFiles, currentPlayingAudio, playerState
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

  var duration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  final _songsCompleter = Completer<bool>();
  List<SongModel> _songs = [];

  List<SongModel> get songs => _songs;
  Completer<bool> get songsCompleter => _songsCompleter;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  updatePosition() {
    audioPlayer.durationStream.listen(
      (d) {
        duration.value = d.toString().split(".")[0];
        max.value = d!.inSeconds.toDouble();
      },
    );
    audioPlayer.positionStream.listen(
      (p) {
        position.value = p.toString().split(".")[0];
        value.value = p.inSeconds.toDouble();
      },
    );
  }

  void changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  void playSong(String? uri, index) {
    // final nSong = songs[index];
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(uri!)),
      );
      audioPlayer.play();
      isPlaying.value = true;
      updatePosition();
      // ignore: empty_catches
    } on Exception {}
  }

  void playNext() {
    final curIndex = playIndex.value;
    final nIndex = (curIndex + 1) % songs.length;
    final nSong = songs[nIndex];
    playSong(nSong.uri, nIndex);
  }

  void checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
    } else {
      checkPermission();
    }
  }

  Future loadDeviceAudios() async {
    final songs = await AudioQueryHandler().getDeviceAudios();
    _songs = songs;
    _songsCompleter.complete(true);
  }
}
