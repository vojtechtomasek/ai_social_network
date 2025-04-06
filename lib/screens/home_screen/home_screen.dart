import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../../provider/post_provider.dart';
import '../../utils/bottom_nav_bar_widget.dart';
import 'widgets/post_card.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = context.watch<PostsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: () => postsProvider.fetchPosts(refresh: true),
        child: postsProvider.posts.isEmpty && postsProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      !postsProvider.isLoadingMore &&
                      postsProvider.hasMorePosts) {
                    postsProvider.loadMorePosts();
                    return true;
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: postsProvider.posts.length +
                      (postsProvider.hasMorePosts ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= postsProvider.posts.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final post = postsProvider.posts[index];
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
                ),
              ),
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 0),
    );
  }
}