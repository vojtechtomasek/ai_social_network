import 'package:flutter/material.dart';

class DiscussionHeader extends StatelessWidget {
  final String discussionName;
  final String message;
  final String createdBy;
  final String timestamp;


  const DiscussionHeader({
    super.key, 
    required this.discussionName, 
    required this.message, 
    required this.createdBy,
    this.timestamp = 'Just now',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$createdBy • ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
                Text(
                  timestamp,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}