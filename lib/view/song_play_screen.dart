import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/model/song_model.dart';

class PlaySong extends StatefulWidget {
  final Song song;
  const PlaySong({super.key, required this.song});

  @override
  State<PlaySong> createState() => _PlaySongState();
}

class _PlaySongState extends State<PlaySong> {
  final player = AudioPlayer();
  Duration? duration;

  @override
  void initState() {
    playSong();
    super.initState();
  }

  Future<void> playSong() async {
    duration = await player.setFilePath(widget.song.path);
    player.play();
    setState(() {});
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.blueGrey,
        Colors.blue,
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.song.album,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
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
        stream: player.positionStream,
        builder: (_, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                format(player.position),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                format(player.duration ?? Duration.zero),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          );
        });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: const Text(
        "Playing from your Library",
        style: TextStyle(color: Colors.white),
      ),
      leading: const BackButton(color: Colors.white),
      actions: [
        IconButton(
            onPressed: () {},
            color: Colors.white,
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
        stream: player.positionStream,
        builder: (context, _) {
          return Slider(
            min: 0.0,
            max: player.duration?.inSeconds.toDouble() ?? 1.0,
            value: player.position.inSeconds.toDouble(),
            onChanged: (value) {
              player.seek(Duration(seconds: value.round()));
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
            color: Colors.white,
            iconSize: 55,
            onPressed: () {
              if (player.position.inSeconds.toInt() > 10) {
                player.seek(player.position - const Duration(seconds: 10));
              } else {
                player.seek(Duration.zero);
              }
            },
            icon: const Icon(Icons.fast_rewind)),
        IconButton(
            color: Colors.white,
            iconSize: 55,
            onPressed: () {
              if (player.playing) {
                player.pause();
              } else {
                player.play();
              }
              setState(() {});
            },
            icon: Icon(
              player.playing
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled_rounded,
            )),
        IconButton(
            color: Colors.white,
            onPressed: () {
              player.seek(player.position + const Duration(seconds: 10));
            },
            iconSize: 55,
            icon: const Icon(
              Icons.fast_forward,
              size: 55,
            ))
      ],
    );
  }

  format(Duration d) {
    if (d.inHours > 0) {
      return d.toString().split('.').first.padLeft(8, "0");
    }
    return d.toString().substring(2, 7);
  }
}
