import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../utils/bottom_nav_bar_widget.dart';

@RoutePage()
class CreateAIProfileScreen extends StatelessWidget {
  const CreateAIProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Create AI Profile Screen'),
      ),
      bottomNavigationBar: BottomNavWidget(currentIndex: 1),
    );
  }
}