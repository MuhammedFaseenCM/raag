import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/controllers/favorite.dart';

class PopUp extends StatefulWidget {
  final SongModel song;
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
          onTap: () {
            addToFavorites(widget.song);
            setState(() {});
          },
          // row has two child icon and text.
          child: const Row(
            children: [
              Icon(Icons.favorite),
              SizedBox(
                // sized box with width 10
                width: 10,
              ),
              Text("Like")
            ],
          ),
        ),
        // popupmenu item 2
        PopupMenuItem(
          value: 2,
          // row has two child icon and text
          onTap: () {},
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
}