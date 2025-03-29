import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/saved_content_provider.dart';
import 'saved_content_error.dart';
import 'saved_posts_list.dart';
import 'saved_discussions_list.dart';

class SavedContentSection extends StatelessWidget {
  final bool showingSavedPosts;
  final Function() loadSavedContent;
  final Widget Function(String title, String subtitle) buildEmptyState;

  const SavedContentSection({
    super.key,
    required this.showingSavedPosts,
    required this.loadSavedContent,
    required this.buildEmptyState,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedContentProvider>(
      builder: (context, savedContentProvider, child) {
        if (savedContentProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (savedContentProvider.error != null) {
          return SavedContentError(
            error: savedContentProvider.error!,
            onRetry: loadSavedContent,
          );
        }

        if (showingSavedPosts) {
          return SavedPostsList(
            savedPosts: savedContentProvider.savedPosts,
            buildEmptyState: buildEmptyState,
          );
        } else {
          return SavedDiscussionsList(
            savedDiscussions: savedContentProvider.savedDiscussions,
            buildEmptyState: buildEmptyState,
          );
        }
      },
    );
  }
}