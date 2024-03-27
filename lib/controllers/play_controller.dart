import 'package:just_audio/just_audio.dart';

class PlayController {
  static final PlayController instance = PlayController._internal();
  factory PlayController() {
    return instance;
  }
  PlayController._internal();
  AudioPlayer player = AudioPlayer();

  Future<Duration?> initSong(String path) async {
    await player.stop();
    return await player.setFilePath(path);
  }

  void playSong() {
    if (player.playing) {
      player.play();
    } else {
      player.pause();
    }
  }
}
