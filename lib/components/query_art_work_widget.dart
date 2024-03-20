import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class QueryArtWork extends StatelessWidget {
  final OnAudioQuery? controller;
  final int songId;
  final double? height;
  final double? width;
  const QueryArtWork({
    super.key,
    this.controller,
    required this.songId,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      controller: controller,
      id: songId,
      type: ArtworkType.AUDIO,
      artworkFit: BoxFit.fitHeight,
      artworkWidth: width ?? 50,
      artworkHeight: height ?? 50,
      nullArtworkWidget: Container(
        width: width ?? 50,
        height: height ?? 50,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: height == null ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: height == null ? null : BorderRadius.circular(10),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("asset/images/default_album.jpg"),
          ),
        ),
      ),
    );
  }
}
