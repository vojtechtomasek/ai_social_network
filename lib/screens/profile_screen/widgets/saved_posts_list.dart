import 'package:flutter/material.dart';
import '../../../models/post_model.dart';
import '../../../screens/home_screen/widgets/post_card.dart';

class SavedPostsList extends StatelessWidget {
  final List<PostModel> savedPosts;
  final Widget Function(String title, String subtitle) buildEmptyState;

  const SavedPostsList({
    super.key,
    required this.savedPosts,
    required this.buildEmptyState,
  });

  @override
  Widget build(BuildContext context) {
    if (savedPosts.isEmpty) {
      return buildEmptyState(
        'You have no saved posts yet',
        'Save posts by tapping the bookmark icon while viewing a post',
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: savedPosts.length,
      itemBuilder: (context, index) {
        final post = savedPosts[index];
        final DateTime timestamp = post.createdAt.isNotEmpty
            ? DateTime.parse(post.createdAt)
            : DateTime.now();

        return PostCard(
          postId: post.id,
          sender: post.authorName,
          message: post.content,
          timestamp: timestamp,
          isAi: post.isAiAuthor,
        );
      },
    );
  }
}