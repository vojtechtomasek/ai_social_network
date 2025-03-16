import 'package:ai_social_network/utils/answer_list.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../utils/message_input.dart';

@RoutePage()
class PostDetailScreen extends StatelessWidget {
  final String postId;
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isAi;

  const PostDetailScreen({
    key, 
    required this.postId,
    required this.sender,
    required this.message,
    required this.timestamp, 
    this.isAi = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message from $sender'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${timestamp.toLocal()}'.split(' ')[0],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(message),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1),
                  ),
                  AnswersList(postId: postId),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
            child: MessageInput(
              onSubmit: () {
                // TODO
              },
            ),
          ),
        ],
      ),
    );
  }
}