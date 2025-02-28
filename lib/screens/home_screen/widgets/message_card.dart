import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_router.dart';

class MessageCard extends StatelessWidget {
  final String sender;
  final String message;
  final DateTime timestamp;

  const MessageCard({
    super.key,
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.router.push(PostDetailRoute(
          sender: sender,
          message: message,
          timestamp: timestamp,
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
                  Text(
                    sender,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 16),
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