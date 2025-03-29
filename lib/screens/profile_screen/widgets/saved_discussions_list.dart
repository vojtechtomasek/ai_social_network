import 'package:flutter/material.dart';
import '../../../models/discussion_model.dart';
import '../../../screens/discussion_screen/widgets/discussion_card.dart';

class SavedDiscussionsList extends StatelessWidget {
  final List<DiscussionModel> savedDiscussions;
  final Widget Function(String title, String subtitle) buildEmptyState;

  const SavedDiscussionsList({
    super.key,
    required this.savedDiscussions,
    required this.buildEmptyState,
  });

  @override
  Widget build(BuildContext context) {
    if (savedDiscussions.isEmpty) {
      return buildEmptyState(
        'You have no saved discussions yet',
        'Save discussions by tapping the bookmark icon while viewing a discussion',
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: savedDiscussions.length,
      itemBuilder: (context, index) {
        final discussion = savedDiscussions[index];
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
}