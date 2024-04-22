

import 'package:hive/hive.dart';
import 'package:raag/controllers/songs_controller.dart';
import 'package:raag/model/song_model.dart';

class NowPlayingController {

  static final NowPlayingController instance = NowPlayingController._internal();

  factory NowPlayingController() {
    return instance;
  }

  NowPlayingController._internal();

  final nowPlayingBox = Hive.box<int>('now_playing');

  Future<void> nowPlayingSong(int songId)async{
    await nowPlayingBox.put('now_playing', songId);
    await getNowPlayingSong();
  }

  Future<Song?> getNowPlayingSong()async{
    int? songId = nowPlayingBox.get('now_playing');
    if(songId == null){
      return null;
    }
    for (var song in songsNotifier.value) {
      if (song.id == songId) {
        return song;
        
      }
    }
    return null;
  }
}