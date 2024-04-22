import 'package:flutter/material.dart';
import 'package:raag/controllers/playlist_controller.dart';
import 'package:raag/model/song_model.dart';

class PlaylistDialog extends StatelessWidget {
  final bool isEdit;
  final Playlist? playlist;
  final TextEditingController controller;
  final int? index;
  const PlaylistDialog({
    super.key,
    required this.isEdit,
    this.playlist,
    required this.controller,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Edit playlist" : "Add new playlist"),
      content: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: "playlist name",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              controller.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        TextButton(
          onPressed: () async {
            isEdit
                ? await PlaylistController.instance.editPlayList(
                    index!,
                    playlist!.copyWith(
                      name: controller.text.trim(),
                    ))
                : await PlaylistController.instance.createPlayList(
                    Playlist(
                      name: controller.text.trim(),
                      songs: [],
                    ),
                  );

            controller.clear();

            if (context.mounted) Navigator.pop(context);
          },
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
