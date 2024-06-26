import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:raag/model/song_model.dart';
import 'package:raag/view/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(SongAdapter().typeId)) {
    Hive.registerAdapter(SongAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistAdapter().typeId)) {
    Hive.registerAdapter(PlaylistAdapter());
  }
  await Hive.openBox<Song>('songs');
  await Hive.openBox<int>('favorites');
  await Hive.openBox<int>('recently_played');
  await Hive.openBox<Playlist>('playlist');
  await Hive.openBox<int>('now_playing');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAAG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

