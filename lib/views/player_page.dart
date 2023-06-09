import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_new/const/color.dart';
import 'package:music_new/const/text_style.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../state/player_state.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final playerState = Get.find<PlayerState>();

  @override
  Widget build(BuildContext context) {
    final songs = playerState.songs;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () {
                return Expanded(
                  child: Container(
                    height: 250,
                    width: 250,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: QueryArtworkWidget(
                      id: songs[playerState.playIndex.value].id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      nullArtworkWidget: const Icon(Icons.music_note,
                          size: 48, color: whiteColor),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            // player controller box
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16))),
                child: Obx(
                  () => Column(
                    children: [
                      Text(
                        songs[playerState.playIndex.value].displayNameWOExt,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                            color: bgDarkColor, family: bold, size: 24),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        songs[playerState.playIndex.value].artist.toString(),
                        style: ourStyle(
                            color: bgDarkColor, family: regular, size: 20),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      // slider
                      Obx(
                        () => Row(
                          children: [
                            Text(playerState.position.value,
                                style: ourStyle(color: bgDarkColor)),
                            Expanded(
                              child: Slider(
                                thumbColor: sliderColor,
                                inactiveColor: bgColor,
                                min: const Duration(seconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                max: playerState.max.value,
                                activeColor: sliderColor,
                                value: playerState.value.value,
                                onChanged: (newValue) {
                                  playerState.changeDurationToSeconds(
                                      newValue.toInt());
                                  newValue = newValue;
                                },
                              ),
                            ),
                            Text(playerState.duration.value,
                                style: ourStyle(color: bgDarkColor)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // pause/play/next etc
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              playerState.playSong(
                                songs[(((playerState.playIndex.value - 1) +
                                            songs.length) %
                                        songs.length)]
                                    .uri,
                                (((playerState.playIndex.value - 1) +
                                        songs.length) %
                                    songs.length),
                              );
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 28,
                            ),
                          ),
                          Obx(
                            () => CircleAvatar(
                              radius: 35,
                              backgroundColor: bgDarkColor,
                              child: Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                  onPressed: () {
                                    if (playerState.isPlaying.value) {
                                      playerState.audioPlayer.pause();
                                      playerState.isPlaying(false);
                                    } else {
                                      playerState.audioPlayer.play();
                                      playerState.isPlaying(true);
                                    }
                                  },
                                  icon: playerState.isPlaying.value
                                      ? const Icon(Icons.pause)
                                      : const Icon(Icons.play_arrow_rounded),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              playerState.playNext();
                              // playerState.playSong(
                              //   songs[(((playerState.playIndex.value + 1) +
                              //               songs.length) %
                              //           songs.length)]
                              //       .uri,
                              //   (((playerState.playIndex.value + 1) +
                              //           songs.length) %
                              //       songs.length),
                              // );
                            },
                            icon: const Icon(Icons.skip_next_rounded, size: 28),
                          ),
                        ],
                      )
                    ],
                  ),
                  //   color: whiteColor,
                  //   borderRadius: BorderRadius.vertical(
                  //     top: Radius.circular(16),
                  //   ),
                  // ),
                  // child: Obx(
                  //   () {
                  //     return Column(
                  //       children: [
                  //         Text(
                  //           songs[playerState.playIndex.value].displayNameWOExt,
                  //           textAlign: TextAlign.center,
                  //           overflow: TextOverflow.ellipsis,
                  //           maxLines: 2,
                  //           style: ourStyle(
                  //               color: bgDarkColor, family: bold, size: 24),
                  //         ),
                  //         const SizedBox(
                  //           height: 12,
                  //         ),
                  //         Text(
                  //           songs[playerState.playIndex.value].artist.toString(),
                  //           style: ourStyle(
                  //               color: bgDarkColor, family: regular, size: 20),
                  //         ),
                  //         const SizedBox(
                  //           height: 12,
                  //         ),
                  //         // slider
                  //         Obx(
                  //           () => Row(
                  //             children: [
                  //               Text(
                  //                 playerState.position.value,
                  //                 style: ourStyle(color: bgDarkColor),
                  //               ),
                  //               Expanded(
                  //                 child: Slider(
                  //                   thumbColor: sliderColor,
                  //                   inactiveColor: bgColor,
                  //                   min: const Duration(seconds: 0)
                  //                       .inSeconds
                  //                       .toDouble(),
                  //                   max: playerState.max.value,
                  //                   activeColor: sliderColor,
                  //                   value: playerState.value.value,
                  //                   onChanged: (newValue) {
                  //                     playerState.changeDurationToSeconds(
                  //                         newValue.toInt());
                  //                     newValue = newValue;
                  //                   },
                  //                 ),
                  //               ),
                  //               Text(
                  //                 playerState.duration.value,
                  //                 style: ourStyle(color: bgDarkColor),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //
                  //         const SizedBox(height: 12),
                  //         // pause/play/next etc
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //           children: [
                  //             IconButton(
                  //               onPressed: () {
                  //                 playerState.playPrevious();
                  //               },
                  //               icon: const Icon(
                  //                 Icons.skip_previous_rounded,
                  //                 size: 28,
                  //               ),
                  //             ),
                  //             Obx(
                  //               () {
                  //                 return CircleAvatar(
                  //                   radius: 35,
                  //                   backgroundColor: bgDarkColor,
                  //                   child: Transform.scale(
                  //                     scale: 2.5,
                  //                     child: IconButton(
                  //                       onPressed: () {
                  //                         playerState.playPause();
                  //                       },
                  //                       icon: playerState.isPlaying.value
                  //                           ? const Icon(Icons.pause)
                  //                           : const Icon(
                  //                               Icons.play_arrow_rounded),
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //             ),
                  //             IconButton(
                  //               onPressed: () {
                  //                 playerState.playNext();
                  //               },
                  //               icon:
                  //                   const Icon(Icons.skip_next_rounded, size: 28),
                  //             ),
                  //           ],
                  //         )
                  //       ],
                  //     );
                  //   },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
