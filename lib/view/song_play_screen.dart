import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/controllers/play_controller.dart';
import 'package:raag/controllers/recently_played_controller.dart';
import 'package:raag/model/song_model.dart';

class PlaySong extends StatefulWidget {
  final Song song;
  final List<Song> songList;
  final int index;
  const PlaySong({
    super.key,
    required this.song,
    required this.songList,
    required this.index,
  });

  @override
  State<PlaySong> createState() => _PlaySongState();
}

class _PlaySongState extends State<PlaySong> {
  Duration? duration;
  PlayController player = PlayController.instance;

  int currentSongIndex = 0;
  Song get currentSong => _currentSong!;

  Song? _currentSong;
  ConcatenatingAudioSource? playList;

  @override
  void initState() {
    currentSongIndex = widget.index;
    _currentSong = widget.song;
    // playSong(true);
    playList = ConcatenatingAudioSource(
      children: List.generate(
        widget.songList.length,
        (index) => AudioSource.file(
          widget.songList[index].path,
        ),
      ),
    );
    player.player.setAudioSource(
      playList!,
      initialIndex:
          widget.songList.indexWhere((song) => song.path == widget.song.path),
    );
    player.player.play();
    player.player.setLoopMode(LoopMode.all);
    player.player.currentIndexStream.listen((index) {
      if (index != null && currentSongIndex != index) {
        // Handle the song change
        setState(() {
          currentSongIndex = index;
          _currentSong =
              widget.songList[(currentSongIndex) % widget.songList.length];
        });
        print("Current song changed to: ${currentSong.title}");
        // Update your UI or perform other actions here
      }
    });
    super.initState();
  }

  Future<void> playSong([bool isInit = false]) async {
    isInit
        ? _currentSong = widget.song
        : _currentSong = widget.songList[currentSongIndex];
    duration = await player.initSong(currentSong);
    await RecentlyPlayed.instance.addToRecentlyPlayed(currentSong);
    await player.player.setLoopMode(LoopMode.all);
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
                  currentSong.title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currentSong.album ?? '',
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
      id: currentSong.id,
      type: ArtworkType.AUDIO,
      artworkBorder: BorderRadius.circular(16.0),
      quality: 100,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: Container(
        height: 250,
        width: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "asset/images/default_album.jpg",
            ),
          ),
        ),
      ),
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
            currentSongIndex > 0
                ? currentSongIndex--
                : currentSongIndex = widget.songList.length - 1;
            playSong();
          },
          icon: const Icon(
            Icons.skip_previous,
          ),
        ),
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
          icon: const Icon(
            Icons.fast_rewind,
          ),
        ),
        IconButton(
            color: AppColors.whiteColor,
            iconSize: 55,
            onPressed: () => player.playSong(setState(() {})),
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
        IconButton(
          color: AppColors.whiteColor,
          iconSize: 55,
          onPressed: () {
            currentSongIndex == widget.songList.length - 1
                ? currentSongIndex = 0
                : currentSongIndex++;
            playSong();
          },
          icon: const Icon(
            Icons.skip_next,
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
