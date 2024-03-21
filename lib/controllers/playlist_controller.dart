import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:raag/model/song_model.dart';

ValueNotifier<List<Playlist>> playlistNotifier = ValueNotifier([]);

class PlaylistController extends ChangeNotifier {
  static final PlaylistController instance = PlaylistController._internal();

  factory PlaylistController() {
    return instance;
  }

  PlaylistController._internal();

  TextEditingController playListController = TextEditingController();

  Future<void> createPlayList(Playlist playlist) async {
    final playListBox = Hive.box<Playlist>('playlist');
    await playListBox.add(playlist);
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playListBox.values.toList());
    playlistNotifier.notifyListeners();
  }

  Future<void> deletePlayList(int index) async {
    final playListBox = Hive.box<Playlist>('playlist');
    await playListBox.deleteAt(index);
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playListBox.values.toList());
    playlistNotifier.notifyListeners();
  }

  Future<void> getPlayList() async {
    final playListBox = Hive.box<Playlist>('playlist');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playListBox.values.toList());
    playlistNotifier.notifyListeners();
  }

  Future<void> addSongToPlayList(int index, Song song) async {
    final playListBox = Hive.box<Playlist>('playlist');
    final playlist = playListBox.getAt(index);
    playlist!.songs.add(song);
    await playListBox.putAt(index, playlist);
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playListBox.values.toList());
    playlistNotifier.notifyListeners();
  }

  Future<void> deleteSongFromPlayList(int index, int songIndex) async {
    final playListBox = Hive.box<Playlist>('playlist');
    final playlist = playListBox.getAt(index);
    playlist!.songs.removeAt(songIndex);
    await playListBox.putAt(index, playlist);
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playListBox.values.toList());
    playlistNotifier.notifyListeners();
  }

  Future<void> deleteAllSongsFromPlayList(int index) async {
    final playListBox = Hive.box<Playlist>('playlist');
    final playlist = playListBox.getAt(index);
    playlist!.songs.clear();
    await playListBox.putAt(index, playlist);
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playListBox.values.toList());
    playlistNotifier.notifyListeners();
  }

  Future<void> editPlayList(int index, Playlist playlist) async {
    final playListBox = Hive.box<Playlist>('playlist');
    await playListBox.putAt(index, playlist);
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playListBox.values.toList());
    playlistNotifier.notifyListeners();
  }

  Future<void> setPlayListName(
      {required BuildContext context,
      bool isEdit = false,
      int? index,
      Playlist? playlist}) async {
    showAdaptiveDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(isEdit ? "Edit play list" : "Add new play list"),
          content: TextFormField(
            controller: playListController,
            decoration: const InputDecoration(
              labelText: "Play list name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  playListController.clear();
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () async {
                  if (isEdit) {
                    await PlaylistController.instance.editPlayList(
                        index!,
                        playlist!.copyWith(
                          name: playListController.text.trim(),
                        ));
                  } else {
                    await PlaylistController.instance.createPlayList(
                      Playlist(
                        name: playListController.text.trim(),
                        songs: [],
                      ),
                    );
                  }
                  playListController.clear();

                  Navigator.pop(context);
                },
                child: const Text("Confirm"))
          ],
        );
      },
    );
  }
}
