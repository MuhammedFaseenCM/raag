import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/controllers/favorite.dart';
import 'package:raag/controllers/songs.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late OnAudioQuery audioQuery;
  List<SongModel> songModel = [];

  @override
  void initState() {
    audioQuery = OnAudioQuery();
    fetchSongs();
    super.initState();
  }

  Future<void> fetchSongs() async {
    Favorite.instance.getFavoriteSongs(songsNotifier.value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFavTop(context),
            _buildFavListView(),
          ],
        ),
      ),
    );
  }

  ValueListenableBuilder _buildFavListView() {
    return ValueListenableBuilder(
      valueListenable: favoriteSongNotifier,
      builder: (context, favSong, _) {
        if (favSong.isEmpty) {
          return const Center(
            child: Text('No songs found'),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: favSong.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(favSong[index].title),
              subtitle: Text(favSong[index].album!),
              trailing: IconButton(
                onPressed: () async {
                  await Favorite.instance
                      .deleteFromFavorites(favSong[index].id, songsNotifier.value);
                  setState(() {});
                },
                icon: const Icon(Icons.favorite),
              ),
              leading: QueryArtworkWidget(
                controller: audioQuery,
                id: favSong[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("asset/images/default_album.jpg"),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Container _buildFavTop(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 250.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blueGrey,
            Colors.blue,
          ],
        ),
      ),
      child: _buildCenterUi(),
    );
  }

  Center _buildCenterUi() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 25.0),
          Container(
            width: 140.0,
            height: 140.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.blueGrey,
                  Colors.blue,
                ],
              ),
            ),
            child: const Icon(
              Icons.favorite,
              size: 70,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Favourite Songs",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      ),
    );
  }
}
