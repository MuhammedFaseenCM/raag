import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:raag/controllers/songs.dart';
import 'package:raag/model/song_model.dart';

ValueNotifier<List<Song>> recentlyPlayed = ValueNotifier<List<Song>>([]);

class RecentlyPlayed extends ChangeNotifier {
  static final RecentlyPlayed instance = RecentlyPlayed._internal();
  factory RecentlyPlayed() {
    return instance;
  }
  RecentlyPlayed._internal();

  Future<void> addToRecentlyPlayed(Song song) async {
    final recentSongs = Hive.box<int>('recently_played');

    if (recentSongs.values.contains(song.id)) {
      recentSongs.delete(recentSongs.values.toList().indexOf(song.id));
      recentlyPlayed.value.remove(song);
      recentlyPlayed.value.insert(0, song);
      return;
    }
    await recentSongs.add(song.id);
    recentlyPlayed.value.insert(0, song);
    if (recentlyPlayed.value.length > 5) {
      recentlyPlayed.value.removeLast();
    }
    recentlyPlayed.notifyListeners();
  }

  Future<void> getRecentSongs() async {
    recentlyPlayed.value.clear();
    for (var song in songsNotifier.value) {
      if (isRecent(song)) {
        recentlyPlayed.value.add(song);
      }
    }
    recentlyPlayed.notifyListeners();
  }

  bool isRecent(Song song) {
    final recentBox = Hive.box<int>('recently_played');
    if (recentBox.values.contains(song.id)) {
      return true;
    }
    return false;
  }
}
