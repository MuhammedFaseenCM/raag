import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:raag/components/add_playlist_dialog.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/components/playlist_bottom_sheet.dart';
import 'package:raag/components/theme.dart';
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
    playlistNotifier.value = playListBox.values.toList();
    playlistNotifier.notifyListeners();
  }

  Future<void> deletePlayList(int index) async {
    final playListBox = Hive.box<Playlist>('playlist');
    await playListBox.deleteAt(index);
    playlistNotifier.value = playListBox.values.toList();
    playlistNotifier.notifyListeners();
  }

  Future<void> getPlayList() async {
    final playListBox = Hive.box<Playlist>('playlist');
    playlistNotifier.value.clear();
    playlistNotifier.value = playListBox.values.toList();
    playlistNotifier.notifyListeners();
  }

  Future<void> addSongToPlayList(
      int index, Song song, BuildContext context) async {
    final playListBox = Hive.box<Playlist>('playlist');
    final playlist = playListBox.getAt(index);
    if (playlist!.songs.contains(song)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Song already added"),
          backgroundColor: AppColors.whiteColor,
        ),
      );
      return;
    }
    playlist.songs.add(song);
    await playListBox.putAt(index, playlist);
    playlistNotifier.value = playListBox.values.toList();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Song added to ${playlist.name}",
            style: AppStyle.bodyText1.copyWith(color: Colors.black),
          ),
          backgroundColor: AppColors.whiteColor,
        ),
      );
    }
    playlistNotifier.notifyListeners();
  }

  Future<void> deleteSongFromPlayList(int index, int songIndex) async {
    final playListBox = Hive.box<Playlist>('playlist');
    final playlist = playListBox.getAt(index);
    playlist!.songs.removeAt(songIndex);
    await playListBox.putAt(index, playlist);
    playlistNotifier.value = playListBox.values.toList();
    playlistNotifier.notifyListeners();
  }

  Future<void> deleteAllSongsFromPlayList(int index) async {
    final playListBox = Hive.box<Playlist>('playlist');
    final playlist = playListBox.getAt(index);
    playlist!.songs.clear();
    await playListBox.putAt(index, playlist);
    playlistNotifier.value = playListBox.values.toList();
    playlistNotifier.notifyListeners();
  }

  Future<void> editPlayList(int index, Playlist playlist) async {
    final playListBox = Hive.box<Playlist>('playlist');
    await playListBox.putAt(index, playlist);
    playlistNotifier.value = playListBox.values.toList();
    playlistNotifier.notifyListeners();
  }

  Future<void> setPlayListName({
    required BuildContext context,
    bool isEdit = false,
    int? index,
    Playlist? playlist,
  }) async {
    showAdaptiveDialog(
      context: context,
      builder: (_) {
        return PlaylistDialog(
          isEdit: isEdit,
          controller: playListController,
          index: index,
          playlist: playlist,
        );
      },
    );
  }

  void showPlaylistBottomSheet(context, Song song) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return PlaylistBottomSheet(song: song);
      },
    );
  }

  Future<void> onPlaylistTap(
    BuildContext context,
    bool isPlaylist,
    int? playlistIndex,
    int? songIndex,
    Song song,
  ) async {
    if (isPlaylist) {
      await PlaylistController.instance
          .deleteSongFromPlayList(playlistIndex ?? 0, songIndex ?? 0);
    } else {
      PlaylistController.instance.showPlaylistBottomSheet(context, song);
    }
  }
}
