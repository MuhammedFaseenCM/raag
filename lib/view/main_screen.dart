import 'dart:math';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/components/bottom_nav_bar.dart';
import 'package:raag/components/now_playing_card.dart';
import 'package:raag/controllers/favorite_controller.dart';
import 'package:raag/controllers/now_playing_controller.dart';
import 'package:raag/controllers/play_controller.dart';
import 'package:raag/controllers/playlist_controller.dart';
import 'package:raag/controllers/recently_played_controller.dart';
import 'package:raag/controllers/songs_controller.dart';
import 'package:raag/model/song_model.dart';
import 'package:raag/view/fav_screen.dart';
import 'package:raag/view/home_screen.dart';
import 'package:raag/view/play_list_screen.dart';
import 'package:raag/view/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late OnAudioQuery audioQuery;
  bool hasPermission = false;
  Song? shuffleSong;

  @override
  void initState() {
    super.initState();
    audioQuery = OnAudioQuery();
    fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: currentIndex,
              children: [
                HomeScreen(shuffleSong: shuffleSong),
                SearchScreen(hasPermission: hasPermission),
                const FavoriteScreen(),
                const PlayListScreen()
              ],
            ),
          ),
          if (PlayController.instance.currentSong != null)
            const NowPlayingCard(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Song> changeSongModel(List<SongModel> songModel) {
    List<Song> songs = [];
    for (var song in songModel) {
      songs.add(
        Song(
          id: song.id,
          title: song.title,
          album: song.album!,
          path: song.data,
        ),
      );
    }
    return songs;
  }

  Future<void> fetchSongs({bool retry = false}) async {
    hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    if (hasPermission) {
      List<SongModel> songModel = await audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      await SongsController.instance.addSongsToHive(
        changeSongModel(songModel),
      );
      await Favorite.instance.getFavoriteSongs();
      await PlaylistController.instance.getPlayList();
      await RecentlyPlayed.instance.getRecentSongs();
      PlayController.instance.currentSong =
          await NowPlayingController.instance.getNowPlayingSong();
      Random random = Random();
      int randomIndex = random.nextInt(songsNotifier.value.length);
      shuffleSong = songsNotifier.value[randomIndex];
    }

    hasPermission ? setState(() {}) : null;
  }
  
  @override
  void dispose() {
    PlayController.instance.player.dispose();
    super.dispose();
  }
}
