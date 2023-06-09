import 'dart:async';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_new/services/audio_player_handler.dart';
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
  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  final _playerHandler = AudioPlayerHandler();
  final _songsCompleter = Completer<bool>();
  List<SongModel> _songs = [];

  List<SongModel> get songs => _songs;
  Completer<bool> get songsCompleter => _songsCompleter;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  @override
  void dispose() {
    _playerHandler.dispose();

    super.dispose();
  }

  void updatePosition() {
    _playerHandler.durationStream.listen(
      (d) {
        duration.value = d.toString().split(".")[0];
        max.value = d!.inSeconds.toDouble();
      },
    );
    _playerHandler.positionStream.listen(
      (p) {
        position.value = p.toString().split(".")[0];
        value.value = p.inSeconds.toDouble();
      },
    );
  }

  void changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    _playerHandler.updatePosition(duration);
  }

  /// changes the song
  void playSong(String uri, index) {
    // final nSong = songs[index];
    playIndex.value = index;
    _playerHandler.playNewSong(uri);
    isPlaying.value = true;
    updatePosition();
    // ignore: empty_catches
  }

  void playNext() {
    final curIndex = playIndex.value;
    final nIndex = (curIndex + 1) % songs.length;
    final nSong = songs[nIndex];

    playSong(nSong.uri!, nIndex);
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
    _songs = songs.where((song) => song.uri != null).toList(growable: false);
    _songsCompleter.complete(true);
  }
}
