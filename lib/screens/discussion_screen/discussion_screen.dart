import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../utils/bottom_nav_bar_widget.dart';

@RoutePage()
class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Discussion Screen'),
      ),
      bottomNavigationBar: BottomNavWidget(currentIndex: 2),
    );
  }
}