import 'package:flutter/material.dart';
import 'package:raag/controllers/playlist_controller.dart';
import 'package:raag/model/song_model.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  TextEditingController playListController = TextEditingController();
  final GlobalKey<_PlayListScreenState> globalKey =
      GlobalKey<_PlayListScreenState>();

  @override
  Widget build(BuildContext context) {
    var currentContext = globalKey.currentContext;
    return Scaffold(
        key: globalKey,
        body: const Center(child: Text("")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAdaptiveDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add new play list"),
                  content: TextFormField(
                    controller: playListController,
                    decoration: const InputDecoration(
                      labelText: "Play list name",
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                          await PlaylistController.instance.createPlayList(
                              Playlist(
                                  name: playListController.text.trim(),
                                  songs: []));
                          if (currentContext!.mounted) {
                            Navigator.pop(currentContext);
                          }
                        },
                        child: const Text("Add"))
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
