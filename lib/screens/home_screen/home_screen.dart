import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../utils/bottom_nav_bar_widget.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home Screen'),
      ),
      bottomNavigationBar: BottomNavWidget(currentIndex: 0),
    );
  }
}