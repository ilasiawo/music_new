import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:music_new/const/color.dart';
import 'package:music_new/const/text_style.dart';
import 'package:music_new/controller/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          actions: [
            IconButton(
                onPressed: () {}, icon: Icon(Icons.search, color: whiteColor))
          ],
          leading: Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
          title: Text(
            "Owais App",
            style: ourStyle(family: bold, size: 18),
          ),
        ),
        body: FutureBuilder<List<SongModel>>(
            future: controller.audioQuery.querySongs(
              ignoreCase: true,
              orderType: OrderType.ASC_OR_SMALLER,
              sortType: null,
              uriType: UriType.EXTERNAL,
            ),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No song found",
                    style: ourStyle(),
                  ),
                );
              } else {
                // Text
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    //itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 4),
                        child: Obx(
                          () => ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            tileColor: bgColor,
                            title: Text(snapshot.data![index].displayNameWOExt,
                                style: ourStyle(family: bold, size: 15)),
                            subtitle: Text("${snapshot.data![index].artist}",
                                style: ourStyle(family: regular, size: 12)),
                            leading: QueryArtworkWidget(
                              id: snapshot.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(
                                Icons.music_note,
                                color: whiteColor,
                                size: 32,
                              ),
                            ),
                            trailing: controller.playIndex.value == index &&
                                    controller.isPlaying.value == true
                                ? const Icon(
                                    Icons.play_arrow,
                                    color: whiteColor,
                                    size: 26,
                                  )
                                : null,
                            onTap: () {
                              controller.playSong(
                                  snapshot.data![index].uri, index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }));
  }
}
