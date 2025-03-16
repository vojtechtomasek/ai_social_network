import 'package:ai_social_network/screens/discussion_screen/widgets/discussion_card.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../models/discussion_model.dart';
import '../../services/discussion_service.dart';
import '../../utils/bottom_nav_bar_widget.dart';

@RoutePage()
class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DiscussionService _discussionService = DiscussionService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussions'),
      ),
      body: FutureBuilder<List<DiscussionModel>>(
        future: _discussionService.fetchDiscussions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No discussions available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final discussion = snapshot.data![index];
                final DateTime timestamp = discussion.createdAt.isNotEmpty 
                    ? DateTime.parse(discussion.createdAt)
                    : DateTime.now();
                  
                return DiscussionCard(
                  discussionId: discussion.id,
                  discussionName: discussion.title,
                  numberOfPosts: discussion.postsCount,
                  createdBy: discussion.authorName,
                  isAi: discussion.isAiAuthor,
                  message: discussion.content,
                  timestamp: timestamp,
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 2),
    );
  }
}