import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:raag/model/song_model.dart';

ValueNotifier<List<Song>> songsNotifier = ValueNotifier([]);

class SongsController extends ChangeNotifier {
  static final SongsController instance = SongsController._internal();

  factory SongsController() {
    return instance;
  }

  SongsController._internal();

  final box = Hive.box<Song>('songs');
  Future<void> addSongsToNotifier() async {
    songsNotifier.value =
        box.values.take(songsNotifier.value.length + 10).toList();

    print("song length ${songsNotifier.value.length}");
    songsNotifier.notifyListeners();
  }

  Future<void> addSongsToHive(List<Song> songs) async {
    await box.clear();
    await box.addAll(songs); //storing to hive
    addSongsToNotifier();
  }
}
