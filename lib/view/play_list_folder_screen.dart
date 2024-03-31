import 'package:flutter/material.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/components/pop_up_menu.dart';
import 'package:raag/components/query_art_work_widget.dart';
import 'package:raag/components/theme.dart';
import 'package:raag/controllers/playlist_controller.dart';
import 'package:raag/model/song_model.dart';

class PlaylistFolderScreen extends StatelessWidget {
  final Playlist playlist;
  final int playListIndex;
  const PlaylistFolderScreen({
    super.key,
    required this.playlist,
    required this.playListIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primaryColor,
            )),
        title: Text(
          playlist.name,
          style: AppStyle.headline2,
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
          valueListenable: playlistNotifier,
          builder: (context, playlists, _) {
            Playlist playlist = playlists[playListIndex];
            if (playlist.songs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${playlist.name} is empty",
                      style: AppStyle.headline1,
                    ),
                    const Text('Please add some songs to enjoy your music')
                  ],
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: playlist.songs.length,
              itemBuilder: (context, index) {
                final Song song = playlist.songs[index];
                return ListTile(
                  leading: QueryArtWork(songId: song.id),
                  title: Text(
                    song.title,
                    style: AppStyle.headline4,
                  ),
                  subtitle: Text(
                    song.album!,
                    style: AppStyle.bodyText1,
                  ),
                  trailing: PopUp(
                    song: song,
                    isPlaylist: true,
                    songIndex: index,
                    playListIndex: playListIndex,
                  ),
                );
              },
            );
          }),
    );
  }
}
