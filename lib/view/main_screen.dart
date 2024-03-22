import 'dart:math';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/components/bottom_nav_bar.dart';
import 'package:raag/controllers/favorite_controller.dart';
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
      Random random = Random();
      int randomIndex = random.nextInt(songsNotifier.value.length);
      shuffleSong = songsNotifier.value[randomIndex];
    }

    hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: currentIndex,
              children: [
                HomeScreen(shuffleSong: shuffleSong),
                SearchScreen(hasPermission: hasPermission),
                const FavoriteScreen(),
                const PlayListScreen()
              ],
            ),
            // _buildNowPlaying(context)
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  Positioned buildNowPlaying(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        width: MediaQuery.sizeOf(context).width,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
          color: Colors.blue[800],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Tum jo aye"),
            IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow))
          ],
        ),
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
}
