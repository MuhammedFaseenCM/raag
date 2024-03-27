import 'package:flutter/material.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/components/theme.dart';
import 'package:raag/controllers/play_controller.dart';

class NowPlayingCard extends StatelessWidget {
  const NowPlayingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
              PlayController.instance.player.icyMetadata?.info?.title ?? '',
              style: AppStyle.bodyText1.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            IconButton(
              onPressed: PlayController.instance.playSong,
              icon:  Icon(
             PlayController.instance.isPlaying?   Icons.pause : Icons.play_arrow,
                color: AppColors.whiteColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}
