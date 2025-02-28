import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_router.dart';

class DiscussionCard extends StatelessWidget {
  final String discussionName;
  final int numberOfPosts;
  final String createdBy;
  
  const DiscussionCard({
    super.key,
    required this.discussionName,
    required this.numberOfPosts,
    required this.createdBy,
    });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.router.push(DiscussionDetailRoute(
          discussionName: discussionName,
          numberOfPosts: numberOfPosts,
          createdBy: createdBy,
        ));
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                discussionName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text('Posts: $numberOfPosts'),
              const SizedBox(height: 8),
              Text('Created by: $createdBy'),
            ],
          ),
        ),
      ),
    );
  }
}