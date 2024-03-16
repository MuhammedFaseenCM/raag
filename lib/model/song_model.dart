import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
part 'song_model.g.dart';

@HiveType(typeId: 0)
class Song extends HiveObject {

  @HiveField(0)
  late String id;

  @HiveField(1)
  late SongModel  songModel;

  Song({
    required this.id,
    required this.songModel,
  });
}

@HiveType(typeId: 1)
class Playlist extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late List<SongModel> songModels;

  Playlist({
    required this.name,
    required this.songModels,
  });
}
