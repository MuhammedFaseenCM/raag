import 'package:flutter/material.dart';
import 'package:raag/model/song_model.dart';

class PlaylistFolderScreen extends StatelessWidget {
  final Playlist playlist;
  const PlaylistFolderScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: playlist.songs.length,
              itemBuilder: (context, index) {
                final Song song = playlist.songs[index];
                return ListTile(
                  title: Text(song.title),
                  subtitle: Text(song.album!),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // Show the popup menu
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
