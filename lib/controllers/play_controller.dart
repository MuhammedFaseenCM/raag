import 'package:just_audio/just_audio.dart';
import 'package:raag/model/song_model.dart';

class PlayController {
  static final PlayController instance = PlayController._internal();
  factory PlayController() {
    return instance;
  }
  PlayController._internal();

  AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  Song? currentSong;

  Future<Duration?> initSong(Song song) async {
    if (isSameSong(song.path)) {
      if (!player.playing) player.play();
      return player.duration;
    }
    await player.stop();
    currentSong = song;
    Duration? duration = await player.setFilePath(song.path);
    playSong();
    return duration;
  }

  bool isSameSong(String path) {
    return currentSong?.path == path;
  }

  void playSong([void setState]) {
    isPlaying = !isPlaying;
    if (!player.playing) {
      player.play();
    } else {
      player.pause();
    }
    setState;
  }
}
