import 'package:flutter/material.dart';
import 'package:raag/components/playlist_popup.dart';
import 'package:raag/components/theme.dart';
import 'package:raag/controllers/playlist_controller.dart';
import 'package:raag/model/song_model.dart';
import 'package:raag/view/play_list_folder_screen.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final GlobalKey<_PlayListScreenState> globalKey =
      GlobalKey<_PlayListScreenState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: ValueListenableBuilder<List<Playlist>>(
          valueListenable: playlistNotifier,
          builder: (context, playlist, child) {
            if (playlist.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No playlist found",
                      style: AppStyle.headline2,
                    ),
                    Text(
                      "Please add some playlist to enjoy your music",
                      style: AppStyle.bodyText1,
                    ),
                  ],
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: playlist.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlaylistFolderScreen(playlist: playlist[index]),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blueGrey,
                            Colors.blueGrey,
                            Colors.blue,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            playlist[index].name,
                            style: AppStyle.headline4
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        PlayListPopUp(
                          index: index,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => PlaylistController.instance.setPlayListName(
              context: context),
          child: const Icon(Icons.add),
        ));
  }
}
