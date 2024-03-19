import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raag/components/pop_up_menu.dart';
import 'package:raag/components/query_art_work_widget.dart';
import 'package:raag/model/song_model.dart';
import 'package:raag/view/song_play_screen.dart';

class ListenableWidget extends StatelessWidget {
  final ValueListenable<List<Song>> valueListenable;
  const ListenableWidget({super.key, required this.valueListenable});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, songs, _) {
        if (songs.isEmpty) return const Center(child: Text('No Songs found'));
        return ListView.builder(
          shrinkWrap: true,
          itemCount: songs.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            Song song = songs[index];
            return ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaySong(song: song),
                ),
              ),
              leading: QueryArtWork(songId: song.id),
              title: Text(
                song.title,
              ),
              subtitle: Text(
                song.album ?? '',
              ),
              trailing: PopUp(song: songs[index]),
            );
          },
        );
      },
    );
  }
}
