import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:raag/components/colors.dart';
import 'package:raag/components/listenable_build.dart';
import 'package:raag/controllers/favorite_controller.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late OnAudioQuery audioQuery;

  @override
  void initState() {
    audioQuery = OnAudioQuery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFavTop(context),
            ListenableWidget(valueListenable: favoriteSongNotifier),
          ],
        ),
      ),
    );
  }

  Container _buildFavTop(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 250.0,
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: _buildCenterUi(),
    );
  }

  Center _buildCenterUi() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 25.0),
          Container(
            width: 140.0,
            height: 140.0,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: const Icon(
              Icons.favorite,
              size: 70,
              color: AppColors.whiteColor,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Favourite Songs",
            style: TextStyle(
                color: AppColors.whiteColor, fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      ),
    );
  }
}
