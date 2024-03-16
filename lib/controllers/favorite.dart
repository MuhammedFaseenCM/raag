import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

void addToFavorites(SongModel song) {
  final favoritesBox = Hive.box<int>('favorites');
  favoritesBox.add(song.id);
}

void deleteFromFavorites(int songId) {
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
  favoritesBox.delete(deleteKey);
}

// Example function to get all favorite songs
Future<List<SongModel>> getFavoriteSongs(List<SongModel> songs) async {
  List<SongModel> favSongs = [];
  for (var song in songs) {
    if (isFavor(song)) {
      favSongs.add(song);
    }
  }
  return favSongs;
}

isFavor(SongModel song) {
  final favoritesBox = Hive.box<int>('favorites');
  if (favoritesBox.values.contains(song.id)) {
    return true;
  }
  return false;
}
