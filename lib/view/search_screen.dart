import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/components/listanable_build.dart';
import 'package:raag/controllers/songs_controller.dart';
import 'package:raag/model/debouncer.dart';
import 'package:raag/model/song_model.dart';

class SearchScreen extends StatefulWidget {
  final bool hasPermission;
  const SearchScreen({super.key, required this.hasPermission});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late OnAudioQuery audioQuery;
  bool hasPermission = false;
  List<Song> searchedSongs = [];
  TextEditingController searchController = TextEditingController();
  final debouncer = Debouncer(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    audioQuery = OnAudioQuery();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
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
              _buildTextField(),
              const SizedBox(height: 4),
              Text(
                "All songs",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue[700],
                ),
              ),
              if (widget.hasPermission)
                ListenableWidget(
                  valueListenable: songsNotifier,
                  searchedSongs: searchedSongs,
                  searchController: searchController,
                )
              else
                const Center(
                  child: Text('Error fetching songs'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    var textFormField = TextFormField(
      controller: searchController,
      onChanged: (value) {
        if (value.trim().isEmpty) return;
        debouncer.run(() {
          searchedSongs.clear();
          for (var song in songsNotifier.value) {
            if (song.title.toLowerCase().contains(value.trim().toLowerCase())) {
              searchedSongs.add(song);
            }
          }
          setState(() {});
        });
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.blueGrey[200],
        hintText: 'What do you want to listen to ?',
        hintStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon: const Icon(Icons.search),
      ),
    );
    return textFormField;
  }

  List<Song> changeSongModel(List<SongModel> songModel) {
    return songModel
        .map(
          (song) => Song(
            id: song.id,
            title: song.title,
            album: song.album!,
            path: song.data,
          ),
        )
        .toList();
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
