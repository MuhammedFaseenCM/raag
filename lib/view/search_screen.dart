import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/components/listenable_build.dart';
import 'package:raag/controllers/songs_controller.dart';
import 'package:raag/model/debouncer.dart';
import 'package:raag/model/song_model.dart';

class SearchScreen extends StatefulWidget {
  final bool hasPermission;
  final void Function() permission;
  const SearchScreen({
    super.key,
    required this.hasPermission,
    required this.permission,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late OnAudioQuery audioQuery;
  bool hasPermission = false;
  List<Song> searchedSongs = [];
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final debouncer = Debouncer(milliseconds: 300);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    audioQuery = OnAudioQuery();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoading = true;
      
      await SongsController.instance.addSongsToNotifier();
      isLoading = false;
      setState(() {});
    }
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
        controller: scrollController,
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
                  color: AppColors.primaryColor,
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
                Center(
                  child: ElevatedButton(
                    onPressed: widget.permission,
                    child: const Text("Add permission"),
                  ),
                ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                )
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
        debouncer.run(
          () {
            searchedSongs.clear();
            for (var song in songsNotifier.value) {
              if (song.title
                  .toLowerCase()
                  .contains(value.trim().toLowerCase())) {
                searchedSongs.add(song);
              }
            }
            setState(() {});
          },
        );
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
}
