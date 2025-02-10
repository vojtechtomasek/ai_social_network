import 'package:ai_social_network/screens/home_screen/widgets/message_card.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../utils/bottom_nav_bar_widget.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          MessageCard(
            sender: 'John Doe', 
            message: 'Test 1',
            timestamp: DateTime.now()
          ),
          MessageCard(
            sender: 'Jane Smith', 
            message: 'Test 2',
            timestamp: DateTime.now()
          )
        ],
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 0),
    );
  }
}