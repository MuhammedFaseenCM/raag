import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/components/pop_up_menu.dart';
import 'package:raag/components/query_art_work_widget.dart';
import 'package:raag/components/theme.dart';
import 'package:raag/controllers/recently_played_controller.dart';
import 'package:raag/model/song_model.dart';
import 'package:raag/view/song_play_screen.dart';

class ListenableWidget extends StatelessWidget {
  final ValueListenable<List<Song>> valueListenable;
  final List<Song>? searchedSongs;
  final TextEditingController? searchController;
  const ListenableWidget({
    super.key,
    required this.valueListenable,
    this.searchedSongs,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, songs, _) {
        if (songs.isEmpty || isSearchEmpty) {
          return const Center(child: Text('No Songs found'));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: isSearching ? searchedSongs?.length ?? 0 : songs.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            final Song song;
            if (isSearching) {
              song = searchedSongs![index];
            } else {
              song = songs[index];
            }
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.headline4.copyWith(
                  color:
                      valueListenable == recentlyPlayed ? AppColors.whiteColor : null,
                ),
              ),
              subtitle: Text(
                song.album ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodyText1.copyWith(
                  color:
                      valueListenable == recentlyPlayed ? AppColors.whiteColor : null,
                ),
              ),
              trailing: PopUp(
                song: songs[index],
                isRecent: valueListenable == recentlyPlayed,
              ),
            );
          },
        );
      },
    );
  }

  bool get isSearching {
    if (searchController == null || searchedSongs == null) {
      return false;
    }
    return searchController!.text.isNotEmpty && searchedSongs!.isNotEmpty;
  }

  bool get isSearchEmpty {
    if (searchController == null || searchedSongs == null) {
      return false;
    }
    return searchController!.text.isNotEmpty && searchedSongs!.isEmpty;
  }
}
