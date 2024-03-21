import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:raag/controllers/songs_controller.dart';
import 'package:raag/model/song_model.dart';

ValueNotifier<List<Song>> favoriteSongNotifier = ValueNotifier([]);

class Favorite extends ChangeNotifier {
  static final Favorite instance = Favorite._internal();

  factory Favorite() {
    return instance;
  }

  Favorite._internal();

  Future<bool> addToFavorites(Song song) async {
    final favoritesBox = Hive.box<int>('favorites');
    if (favoritesBox.values.contains(song.id)) {
      return false;
    }
    await favoritesBox.add(song.id);
    favoriteSongNotifier.value.add(song);
    favoriteSongNotifier.notifyListeners();
    return true;
  }

  Future<void> deleteFromFavorites(int songId) async {
    final favoritesBox = Hive.box<int>('favorites');
    int deleteKey = 0;
    if (!favoritesBox.values.contains(songId)) {
      return;
    }
    final Map<dynamic, int> favorMap = favoritesBox.toMap();
    favorMap.forEach((key, value) {
      if (value == songId) {
        deleteKey = key;
      }
    });
    await favoritesBox.delete(deleteKey);
    await getFavoriteSongs();
  }

  Future<void> getFavoriteSongs() async {
    favoriteSongNotifier.value.clear();
    for (var song in songsNotifier.value) {
      if (isFavor(song)) {
        favoriteSongNotifier.value.add(song);
      }
    }
    favoriteSongNotifier.notifyListeners();
  }

  bool isFavor(Song song) {
    final favoritesBox = Hive.box<int>('favorites');
    if (favoritesBox.values.contains(song.id)) {
      return true;
    }
    return false;
  }
}
