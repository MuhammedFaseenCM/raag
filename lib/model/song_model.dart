import 'package:hive/hive.dart';
part 'song_model.g.dart';

@HiveType(typeId: 0)
class Song extends HiveObject {

  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String? album;

  @HiveField(3)
  late String path;

  Song({
    required this.id,
    required this.title,
    this.album,
    required this.path,
  });
}

@HiveType(typeId: 1)
class Playlist extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late List<Song> songs;

  @HiveField(2)
  late int? id;

  /// Returns a new instance of [Playlist] based on the given parameters
  Playlist({
    required this.name,
    required this.songs,
    this.id,
  });
}
