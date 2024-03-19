import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/components/pop_up_menu.dart';
import 'package:raag/model/song_model.dart';
import 'package:raag/view/song_play_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late OnAudioQuery audioQuery;
  bool hasPermission = false;

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

    hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            const Text(
              "Search",
              style: TextStyle(
                fontSize: 25,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50,
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.blueGrey[200],
                  hintText: 'What do you want to listen to ?',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "All songs",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue[700],
              ),
            ),
            hasPermission
                ? FutureBuilder<List<SongModel>>(
                    future: audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error fetching songs'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No songs found'),
                        );
                      }
                      List<SongModel> songs = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: songs.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaySong(
                                    song: songs[index],
                                  ),
                                ),
                              );
                            },
                            leading: QueryArtworkWidget(
                              controller: audioQuery,
                              id: songs[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.all(4.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "asset/images/default_album.jpg"),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              songs[index].title,
                              style: const TextStyle(color: Colors.blue),
                            ),
                            subtitle: Text(
                              songs[index].album!,
                              style: const TextStyle(color: Colors.blue),
                            ),
                            trailing: PopUp(song: songs[index]),
                          );
                        },
                      );
                    })
                : const Center(
                    child: Text('Error fetching songs'),
                  ),
          ],
        ),
      ),
    );
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

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry A')),
            ),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(child: Text('Entry B')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[300],
            child: const Center(child: Text('Entry C')),
          ),
        ],
      ),
    );
  }
}
