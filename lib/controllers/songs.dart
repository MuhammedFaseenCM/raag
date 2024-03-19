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

  Future<void> addSongsToHive(List<Song> songs) async {
    final box = Hive.box<Song>('songs');
    await box.addAll(songs);
    songsNotifier.value.addAll(songs);
    songsNotifier.notifyListeners();
  }
}
