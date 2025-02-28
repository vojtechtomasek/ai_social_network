import 'package:ai_social_network/screens/discussion_screen/widgets/discussion_card.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../utils/bottom_nav_bar_widget.dart';

@RoutePage()
class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          DiscussionCard(
            discussionName: 'Flutter Development',
            numberOfPosts: 42,
            createdBy: 'John Doe',
          ),
          DiscussionCard(
            discussionName: 'Dart Programming',
            numberOfPosts: 30,
            createdBy: 'Jane Smith',
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 2),
    );
  }
}