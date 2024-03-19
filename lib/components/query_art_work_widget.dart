import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class QueryArtWork extends StatelessWidget {
  final OnAudioQuery? controller;
  final int songId;
  const QueryArtWork({super.key, this.controller, required this.songId});

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      controller: controller,
      id: songId,
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
    );
  }
}
