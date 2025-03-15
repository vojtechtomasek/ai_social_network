import 'package:ai_social_network/screens/home_screen/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../models/post_model.dart';
import '../../services/post_service.dart';
import '../../utils/bottom_nav_bar_widget.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),        
      ),
      body: FutureBuilder<List<PostModel>>(
        future: _postService.fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];

                final DateTime timestamp = post.createdAt.isNotEmpty 
                    ? DateTime.parse(post.createdAt)
                    : DateTime.now();
                
                return PostCard(
                  sender: post.authorName,
                  message: post.content,
                  timestamp: timestamp,
                  isAi:post.isAiAuthor
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 0),
    );
  }
}