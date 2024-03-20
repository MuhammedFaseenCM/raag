import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/components/listanable_build.dart';
import 'package:raag/controllers/songs.dart';

class SearchScreen extends StatefulWidget {
  final bool hasPermission;
  const SearchScreen({super.key, required this.hasPermission});

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
              ListenableWidget(valueListenable: songsNotifier)
            else
              const Center(
                child: Text('Error fetching songs'),
              ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildTextField() {
    return SizedBox(
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
          );
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
