import 'package:flutter/material.dart';

class HomePageNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomePageNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: const Color(0xFF001F3F), // Navy blue background
      selectedItemColor: const Color(0xFFFFD700), // Gold selected item
      unselectedItemColor: Colors.white70, // White unselected items
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}