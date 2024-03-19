import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      selectedItemColor: Colors.blue[100],
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.blueGrey,
      items: [
        BottomNavigationBarItem(
            icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: "Home"),
        const BottomNavigationBarItem(
            icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(
            icon: Icon(
                currentIndex == 2 ? Icons.favorite : Icons.favorite_border),
            label: "Favorite"),
        const BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play_sharp), label: "Playlist"),
      ],
    );
  }
}
