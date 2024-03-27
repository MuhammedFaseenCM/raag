import 'package:flutter/material.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/controllers/playlist_controller.dart';

class PlayListPopUp extends StatefulWidget {
  final int index;
  const PlayListPopUp({
    super.key,
    required this.index,
  });

  @override
  State<PlayListPopUp> createState() => _PlayListPopUpState();
}

class _PlayListPopUpState extends State<PlayListPopUp> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      iconColor: AppColors.whiteColor,
      itemBuilder: (_) => [
        // popupmenu item 1
        PopupMenuItem(
          value: 1,
          onTap: () async {
            PlaylistController.instance.playListController.text =
                playlistNotifier.value[widget.index].name;

            await PlaylistController.instance.setPlayListName(
              isEdit: true,
              context: context,
              index: widget.index,
              playlist: playlistNotifier.value[widget.index],
            );
          },
          // row has two child icon and text.
          child: const Row(
            children: [
              Icon(
                Icons.edit_note_sharp,
                color: AppColors.lightPrimaryColor,
              ),
              SizedBox(width: 10),
              Text("Edit")
            ],
          ),
        ),
        // popupmenu item 2
        PopupMenuItem(
          value: 2,
          // row has two child icon and text
          onTap: () {
            PlaylistController.instance.deletePlayList(widget.index);
          },
          child: const Row(
            children: [
              Icon(Icons.delete),
              SizedBox(
                // sized box with width 10
                width: 10,
              ),
              Text("Delete")
            ],
          ),
        ),
      ],
      offset: const Offset(0, 50),
      elevation: 2,
    );
  }
}
