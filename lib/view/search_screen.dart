import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:raag/view/song_play_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late OnAudioQuery audioQuery;

  @override
  void initState() {
    super.initState();
    audioQuery = OnAudioQuery();
    fetchSongs();
  }

  Future<List<SongModel>> fetchSongs() async {
     bool isGranted = await audioQuery.checkAndRequest();
    if (!isGranted) {
      await Permission.audio.request();
    }
    return await audioQuery.querySongs();
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
            FutureBuilder(
                future: fetchSongs(),
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
                              ));
                        },
                        leading: QueryArtworkWidget(
                          //  controller: audioQuery,
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
                                        "asset/images/default_album.jpg"))),
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
                        trailing: const Icon(
                          Icons.more_vert,
                          color: Colors.blue,
                        ),
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
