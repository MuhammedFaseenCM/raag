import 'package:just_audio/just_audio.dart';

class PlayController {
  static final PlayController instance = PlayController._internal();
  factory PlayController() {
    return instance;
  }
  PlayController._internal();

  AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  String songPath = '';

  Future<Duration?> initSong(String path) async {
    if (isSameSong(path)) {
      return player.duration;
    }
    await player.stop();
    songPath = path;
    return await player.setFilePath(path);
  }

  bool isSameSong(String path) {
    return songPath == path;
  }

  void playSong() {
    isPlaying = !isPlaying;
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }
}
