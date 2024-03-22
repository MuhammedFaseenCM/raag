import 'package:flutter/material.dart';
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

  void showPlaylistBottomSheet(context, Song song) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ValueListenableBuilder(
          valueListenable: playlistNotifier,
          builder: (context, playlist, child) {
            return SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text("Add song to playlist"),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: playlist.length,
                      itemBuilder: (context, index) {
                        final Playlist playList = playlist[index];
                        return ListTile(
                          title: Text(playList.name),
                          onTap: () {
                            addSongToPlayList(index, song);
                          },
                          leading: const Icon(Icons.playlist_add),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              PlaylistController.instance.deletePlayList(index);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
