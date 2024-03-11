import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            Positioned(
              bottom: 0.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                width: MediaQuery.sizeOf(context).width,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0)),
                  color: Colors.blue[800],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tum jo aye"),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.play_arrow))
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (selectedIndex) {
              setState(() {
                currentIndex = selectedIndex;
              });
            },
            selectedItemColor: Colors.blue[100],
            unselectedItemColor: Colors.white,
            backgroundColor: Colors.blueGrey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: "Search"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: "Favorite"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_play_sharp), label: "Playlist"),
            ]),
      ),
    );
  }
}
