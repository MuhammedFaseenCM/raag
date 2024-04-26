import 'package:flutter/material.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/components/listenable_build.dart';
import 'package:raag/components/query_art_work_widget.dart';
import 'package:raag/controllers/recently_played_controller.dart';
import 'package:raag/controllers/songs_controller.dart';
import 'package:raag/model/song_model.dart';
import 'package:raag/view/song_play_screen.dart';

class HomeScreen extends StatefulWidget {
  final Song? shuffleSong;
  final bool hasPermission;
  const HomeScreen({
    super.key,
    this.shuffleSong,
    required this.hasPermission,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: widget.hasPermission
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Happy Music",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Today's Shuffled song for you",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaySong(
                                song: widget.shuffleSong!,
                                index: 0,
                                songList: songsNotifier.value,
                              ),
                            ),
                          );
                        },
                        child: QueryArtWork(
                          songId: widget.shuffleSong?.id ?? 0,
                          width: 320,
                          height: 250,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Your Playlist",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.whiteColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'asset/images/sita_ramam.jpg'))),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blue[700],
                          size: 120,
                        )
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 2),
                    const Text(
                      'Frequently played',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.whiteColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'asset/images/sita_ramam.jpg'))),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 2),
                    const Text(
                      "Recently played",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.whiteColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    ListenableWidget(valueListenable: recentlyPlayed),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text("Please allow audio permission"),
            ),
    );
  }
}
