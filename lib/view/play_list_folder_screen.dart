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
    );
  }
}
