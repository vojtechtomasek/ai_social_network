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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Consumer<PostsProvider>(
        builder: (context, postsProvider, child) {
          if (postsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (postsProvider.error != null) {
            return Center(child: Text('Error: ${postsProvider.error}'));
          } else if (postsProvider.posts.isEmpty) {
            return const Center(child: Text('No posts available'));
          } else {
            return RefreshIndicator(
              onRefresh: () => postsProvider.fetchPosts(),
              child: ListView.builder(
                itemCount: postsProvider.posts.length,
                itemBuilder: (context, index) {
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
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 0),
    );
  }
}