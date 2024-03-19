import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<SongModel>> favoriteSongNotifier = ValueNotifier([]);

class Favorite extends ChangeNotifier {
  static final Favorite instance = Favorite._internal();

  factory Favorite() {
    return instance;
  }

  Favorite._internal();

  Future<void> addToFavorites(SongModel song) async {
    final favoritesBox = Hive.box<int>('favorites');
    await favoritesBox.add(song.id);
    favoriteSongNotifier.value.add(song);
    favoriteSongNotifier.notifyListeners();
  }

  Future<void> deleteFromFavorites(int songId, List<SongModel> songs) async {
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
    await getFavoriteSongs(songs);
  }

  Future<void> getFavoriteSongs(List<SongModel> songs) async {
    favoriteSongNotifier.value.clear();
    for (var song in songs) {
      if (isFavor(song)) {
        favoriteSongNotifier.value.add(song);
      }
    }
    favoriteSongNotifier.notifyListeners();
  }

  bool isFavor(SongModel song) {
    final favoritesBox = Hive.box<int>('favorites');
    if (favoritesBox.values.contains(song.id)) {
      return true;
    }
    return false;
  }
}
