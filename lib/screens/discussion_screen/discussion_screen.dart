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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiscussionsProvider>().fetchDiscussions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final discussionsProvider = context.watch<DiscussionsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussions'),
      ),
      body: RefreshIndicator(
        onRefresh: () => discussionsProvider.fetchDiscussions(refresh: true),
        child: discussionsProvider.discussions.isEmpty &&
                discussionsProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      !discussionsProvider.isLoadingMore &&
                      discussionsProvider.hasMoreDiscussions) {
                    discussionsProvider.loadMoreDiscussions();
                    return true;
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: discussionsProvider.discussions.length +
                      (discussionsProvider.hasMoreDiscussions ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= discussionsProvider.discussions.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

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
              ),
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 3),
    );
  }
}