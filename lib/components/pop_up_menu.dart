import 'package:flutter/material.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/controllers/favorite_controller.dart';
import 'package:raag/controllers/playlist_controller.dart';
import 'package:raag/model/song_model.dart';

class PopUp extends StatefulWidget {
  final Song song;
  final bool isPlaylist;
  final int? playListIndex;
  final bool isRecent;
  final int? songIndex;
  const PopUp({
    super.key,
    required this.song,
    this.isPlaylist = false,
    this.playListIndex,
    this.songIndex,
    this.isRecent = false,
  });

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => [
        // popupmenu item 1
        PopupMenuItem(
          value: 1,
          onTap: () async {
            await Favorite.instance.onFavoriteTap(context, widget.song);
            setState(() {});
          },
          // row has two child icon and text.
          child: Row(
            children: [
              Icon(
                isFavSong(widget.song) ? Icons.favorite_border : Icons.favorite,
                color: AppColors.lightPrimaryColor,
              ),
              const SizedBox(width: 10),
              Text(isFavSong(widget.song) ? "Unlike" : "Like")
            ],
          ),
        ),
        // popupmenu item 2
        PopupMenuItem(
          value: 2,
          onTap: () async {
            await PlaylistController.instance.onPlaylistTap(
              context,
              widget.isPlaylist,
              widget.playListIndex,
              widget.songIndex,
              widget.song,
            );
            setState(() {});
          },
          child: Row(
            children: [
              Icon(widget.isPlaylist ? Icons.delete : Icons.playlist_add),
              const SizedBox(
                width: 10,
              ),
              Text(widget.isPlaylist ? 'Delete' : "Playlist")
            ],
          ),
        ),
      ],
      offset: const Offset(0, 50),
      elevation: 2,
      iconColor:
          widget.isRecent ? AppColors.whiteColor : AppColors.primaryColor,
    );
  }

  bool isFavSong(Song song) {
    return Favorite.instance.isFavor(song);
  }
}
