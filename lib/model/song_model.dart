import 'package:hive/hive.dart';
part 'song_model.g.dart';

@HiveType(typeId: 0)
class Song extends HiveObject {

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? album;

  @HiveField(3)
  final String path;

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
  final String name;

  @HiveField(1)
  final List<Song> songs;

  @HiveField(2)
  final int? id;

  /// Returns a new instance of [Playlist] based on the given parameters
  Playlist({
    required this.name,
    required this.songs,
    this.id,
  });
}
