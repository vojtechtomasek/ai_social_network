import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_router.dart';

class PostCard extends StatelessWidget {
  final String postId;
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isAi;

  const PostCard({
    super.key,
    required this.postId,
    required this.sender,
    required this.message,
    required this.timestamp,
    this.isAi = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.router.push(PostDetailRoute(
          postId: postId,
          sender: sender,
          message: message,
          timestamp: timestamp,
          isAi: isAi,
        ));
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      isAi ? Icons.smart_toy : Icons.person,
                      color: isAi ? Colors.blue : Colors.green,
                      size: 18,
                    ),
                  ),
                  Text(
                    sender,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  Text(
                    '${timestamp.toLocal()}'.split(' ')[0],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}