import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/controllers/play_controller.dart';
import 'package:raag/controllers/recently_played_controller.dart';
import 'package:raag/model/song_model.dart';

class PlaySong extends StatefulWidget {
  final Song song;
  const PlaySong({super.key, required this.song});

  @override
  State<PlaySong> createState() => _PlaySongState();
}

class _PlaySongState extends State<PlaySong> {
  Duration? duration;
  PlayController player = PlayController.instance;

  @override
  void initState() {
    playSong();
    super.initState();
  }

  Future<void> playSong() async {
    duration = await PlayController.instance.initSong(widget.song.path);
    player.playSong();
    await RecentlyPlayed.instance.addToRecentlyPlayed(widget.song);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildAlbumImage(),
                const SizedBox(height: 20),
                Text(
                  widget.song.title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.song.album ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 10),
                _buildSongSlider(),
                _buildPositionText(),
                const SizedBox(height: 20),
                _buildActionButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<Duration> _buildPositionText() {
    return StreamBuilder<Duration>(
      stream: player.player.positionStream,
      builder: (_, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              format(player.player.position),
              style: const TextStyle(color: AppColors.whiteColor),
            ),
            Text(
              format(player.player.duration ?? Duration.zero),
              style: const TextStyle(color: AppColors.whiteColor),
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.transparentColor,
      title: const Text(
        "Playing from your Library",
        style: TextStyle(color: AppColors.whiteColor),
      ),
      leading: const BackButton(color: AppColors.whiteColor),
      actions: [
        IconButton(
            onPressed: () {},
            color: AppColors.whiteColor,
            icon: const Icon(Icons.more_vert))
      ],
    );
  }

  Center _buildAlbumImage() {
    return Center(
        child: QueryArtworkWidget(
      artworkHeight: 250,
      artworkWidth: 320,
      id: widget.song.id,
      type: ArtworkType.AUDIO,
      quality: 100,
      artworkFit: BoxFit.fitHeight,
      nullArtworkWidget: Image.asset("asset/images/default_album.jpg"),
    ));
  }

  StreamBuilder<Duration> _buildSongSlider() {
    return StreamBuilder(
        stream: player.player.positionStream,
        builder: (context, _) {
          return Slider(
            min: 0.0,
            max: player.player.duration?.inSeconds.toDouble() ?? 1.0,
            value: player.player.position.inSeconds.toDouble(),
            onChanged: (value) {
              player.player.seek(Duration(seconds: value.round()));
              //   setState(() {});
            },
            autofocus: true,
          );
        });
  }

  Row _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            color: AppColors.whiteColor,
            iconSize: 55,
            onPressed: () {
              if (player.player.position.inSeconds.toInt() > 10) {
                player.player
                    .seek(player.player.position - const Duration(seconds: 10));
              } else {
                player.player.seek(Duration.zero);
              }
            },
            icon: const Icon(Icons.fast_rewind)),
        IconButton(
            color: AppColors.whiteColor,
            iconSize: 55,
            onPressed: player.playSong,
            icon: Icon(
              player.player.playing
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled_rounded,
            )),
        IconButton(
          color: AppColors.whiteColor,
          onPressed: () {
            player.player
                .seek(player.player.position + const Duration(seconds: 10));
          },
          iconSize: 55,
          icon: const Icon(
            Icons.fast_forward,
            size: 55,
          ),
        ),
      ],
    );
  }

 String format(Duration d) {
    if (d.inHours > 0) {
      return d.toString().split('.').first.padLeft(8, "0");
    }
    return d.toString().substring(2, 7);
  }
}
