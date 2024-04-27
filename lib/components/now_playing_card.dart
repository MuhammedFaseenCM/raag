import 'package:flutter/material.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/components/theme.dart';
import 'package:raag/controllers/play_controller.dart';

class NowPlayingCard extends StatefulWidget {
  const NowPlayingCard({super.key});

  @override
  State<NowPlayingCard> createState() => _NowPlayingCardState();
}

class _NowPlayingCardState extends State<NowPlayingCard> {
  @override
  Widget build(BuildContext context) {
    return PlayController.instance.currentSong != null
        ? Positioned(
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              width: MediaQuery.sizeOf(context).width,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                color: Colors.blue[800],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    PlayController.instance.currentSong?.title ?? '',
                    style: AppStyle.headline5.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            PlayController.instance.playSong(setState(() {})),
                        icon: Icon(
                            PlayController.instance.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: AppColors.whiteColor),
                        color: AppColors.whiteColor,
                      ),
                      if (!PlayController.instance.isPlaying)
                        IconButton(
                          onPressed: () =>
                              PlayController.instance.stopSong(setState(() {})),
                          icon: const Icon(Icons.stop,
                              color: AppColors.whiteColor),
                          color: AppColors.whiteColor,
                        ),
                    ],
                  )
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
