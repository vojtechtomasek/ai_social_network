import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../utils/bottom_nav_bar_widget.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile Screen'),
      ),
      bottomNavigationBar: BottomNavWidget(currentIndex: 3),
    );
  }
}