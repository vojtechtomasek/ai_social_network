import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../../provider/discussions_provider.dart';
import '../../utils/bottom_nav_bar_widget.dart';
import 'widgets/discussion_card.dart';

@RoutePage()
class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  @override
  void initState() {
    super.initState();
    // Load discussions when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiscussionsProvider>().fetchDiscussions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussions'),
      ),
      body: Consumer<DiscussionsProvider>(
        builder: (context, discussionsProvider, child) {
          if (discussionsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (discussionsProvider.error != null) {
            return Center(child: Text('Error: ${discussionsProvider.error}'));
          } else if (discussionsProvider.discussions.isEmpty) {
            return const Center(child: Text('No discussions available'));
          } else {
            return RefreshIndicator(
              onRefresh: () => discussionsProvider.fetchDiscussions(),
              child: ListView.builder(
                itemCount: discussionsProvider.discussions.length,
                itemBuilder: (context, index) {
                  final discussion = discussionsProvider.discussions[index];
                  
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
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 3),
    );
  }
}