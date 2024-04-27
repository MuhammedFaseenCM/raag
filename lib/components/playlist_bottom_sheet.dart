import 'package:flutter/material.dart';
import 'package:raag/controllers/playlist_controller.dart';
import 'package:raag/model/song_model.dart';

class PlaylistBottomSheet extends StatelessWidget {
  final Song song;
  const PlaylistBottomSheet({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: playlistNotifier,
      builder: (context, playlists, child) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("Add song to playlist"),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final Playlist playlist = playlists[index];
                    return ListTile(
                      title: Text(playlist.name),
                      onTap: () {
                        PlaylistController.instance
                            .addSongToPlayList(index, song, context);
                        Navigator.pop(context);
                      },
                      leading: const Icon(Icons.playlist_add),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          PlaylistController.instance.deletePlayList(index);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
