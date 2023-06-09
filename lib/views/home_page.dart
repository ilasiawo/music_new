import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_new/const/color.dart';
import 'package:music_new/const/text_style.dart';
import 'package:music_new/views/player_page.dart';
import 'package:music_new/state/player_state.dart';
import 'package:music_new/services/audio_query_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../state/player_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final playerState = Get.put(PlayerState());

  @override
  void initState() {
    super.initState();

    playerState.loadDeviceAudios();
  }

  void _onPlayerClick(List<SongModel> songs, int index) {
    // it works as Navigator.push
    Get.to(
      () => const PlayerPage(),
      transition: Transition.downToUp,
    );
    playerState.playSong(
      songs[index].uri,
      index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.music_note_sharp,
              color: whiteColor,
            ),
          ),
        ],
        leading: const Icon(
          Icons.sort_rounded,
          color: whiteColor,
        ),
        title: Text(
          "Owais App",
          style: ourStyle(family: bold, size: 18),
        ),
      ),
      body: FutureBuilder<bool>(
        future: playerState.songsCompleter.future,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final songs = playerState.songs;

            if (songs.isEmpty) {
              return Center(
                child: Text(
                  "No song found",
                  style: ourStyle(),
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                physics: const BouncingScrollPhysics(),
                itemCount: songs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Obx(
                      () {
                        return ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          tileColor: bgColor,
                          title: Text(songs[index].displayNameWOExt,
                              style: ourStyle(family: bold, size: 15)),
                          subtitle: Text("${songs[index].artist}",
                              style: ourStyle(family: regular, size: 12)),
                          leading: QueryArtworkWidget(
                            id: songs[index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              color: whiteColor,
                              size: 32,
                            ),
                          ),
                          trailing: playerState.playIndex.value == index &&
                                  playerState.isPlaying.value == true
                              ? const Icon(
                                  Icons.play_arrow,
                                  color: whiteColor,
                                  size: 26,
                                )
                              : null,
                          onTap: () => _onPlayerClick(songs, index),
                        );
                      },
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
