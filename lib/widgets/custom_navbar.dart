import 'package:flutter/material.dart';
import '../pages/homepage.dart';
import '../pages/historypage.dart';
import '../pages/guidepage.dart';
import '../pages/profilepage.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // Avoid reloading same page

    Widget page;
    switch (index) {
      case 0:
        page = const Homepage();
        break;
      case 1:
        page = const HistoryPage();
        break;
      case 2:
        page = const GuidePage();
        break;
      case 3:
        page = const ProfilePage();
        break;
      default:
        page = const Homepage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: "Guide"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
