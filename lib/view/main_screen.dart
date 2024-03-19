import 'package:flutter/material.dart';
import 'package:raag/components/bottom_nav_bar.dart';
import 'package:raag/view/fav_screen.dart';
import 'package:raag/view/home_screen.dart';
import 'package:raag/view/play_list_screen.dart';
import 'package:raag/view/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: currentIndex,
              children: const [
                HomeScreen(),
                SearchScreen(),
                FavoriteScreen(),
                PlayListScreen()
              ],
            ),
            // _buildNowPlaying(context)
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  Positioned _buildNowPlaying(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        width: MediaQuery.sizeOf(context).width,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
          color: Colors.blue[800],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Tum jo aye"),
            IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow))
          ],
        ),
      ),
    );
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
