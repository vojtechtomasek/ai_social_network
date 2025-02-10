import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../routes/app_router.dart';

class BottomNavWidget extends StatelessWidget {
  final int currentIndex;

  const BottomNavWidget({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    final routes = [
      const HomeRoute(),
      const CreateAIProfileRoute(),
      const DiscussionRoute(),
      const ProfileRoute(),
    ];

    context.router.replace(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: const IconThemeData(size: 24),
      unselectedIconTheme: const IconThemeData(size: 24),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.create), label: 'Create AI Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Discussion'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
