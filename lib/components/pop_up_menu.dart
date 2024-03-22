import 'package:flutter/material.dart';
import 'package:raag/controllers/favorite_controller.dart';
import 'package:raag/controllers/playlist_controller.dart';
import 'package:raag/model/song_model.dart';

class PopUp extends StatefulWidget {
  final Song song;
  const PopUp({super.key, required this.song});

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
            if (favoriteSongNotifier.value.contains(widget.song)) {
              await Favorite.instance.deleteFromFavorites(widget.song.id);
            } else {
              bool result = await Favorite.instance.addToFavorites(widget.song);
              if (!result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Already in favorites'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }
            setState(() {});
          },
          // row has two child icon and text.
          child: Row(
            children: [
              Icon(
                isFavSong(widget.song) ? Icons.favorite_border : Icons.favorite,
                color: Colors.lightBlue,
              ),
              const SizedBox(width: 10),
              Text(isFavSong(widget.song) ? "Unlike" : "Like")
            ],
          ),
        ),
        // popupmenu item 2
        PopupMenuItem(
          value: 2,
          // row has two child icon and text
          onTap: () {
            PlaylistController.instance
                .showPlaylistBottomSheet(context, widget.song);
          },
          child: const Row(
            children: [
              Icon(Icons.playlist_add),
              SizedBox(
                // sized box with width 10
                width: 10,
              ),
              Text("Playlist")
            ],
          ),
        ),
      ],
      offset: const Offset(0, 50),
      elevation: 2,
    );
  }

  bool isFavSong(Song song) {
    return Favorite.instance.isFavor(song);
  }
}
