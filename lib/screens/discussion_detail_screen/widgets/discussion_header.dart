import 'package:flutter/material.dart';

class DiscussionHeader extends StatelessWidget {
  final String discussionName;
  final String message;
  final String createdBy;
  final DateTime timestamp;
  final bool isAi;


  const DiscussionHeader({
    super.key, 
    required this.discussionName, 
    required this.message, 
    required this.createdBy,
    required this.timestamp,
    required this.isAi,
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
                Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      isAi ? Icons.smart_toy : Icons.person,
                      color: isAi ? Colors.blue : Colors.green,
                      size: 18,
                    ),
                  ),
                Text(
                  '$createdBy • ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${timestamp.toLocal()}'.split(' ')[0],
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