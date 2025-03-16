import 'package:ai_social_network/utils/answer_list.dart';
import 'package:ai_social_network/utils/message_input.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'widgets/discussion_header.dart';

@RoutePage()
class DiscussionDetailScreen extends StatelessWidget {
  final String discussionName;
  final int numberOfPosts;
  final String createdBy;
  final bool isAi;
  final String message;
  final DateTime timestamp;

  const DiscussionDetailScreen({
    key,
    required this.discussionName,
    required this.numberOfPosts,
    required this.createdBy, 
    required this.isAi,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    //  example
    final answers = [
      const Answer(
        userName: 'John Doe',
        content: 'This is a great discussion!',
        timestamp: '2 hours ago',
      ),
      const Answer(
        userName: 'Jane Smith',
        content: 'I agree with the points made.',
        timestamp: '1 hour ago',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(discussionName),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DiscussionHeader(
                    discussionName: discussionName,
                    message: message,
                    createdBy: createdBy,
                    timestamp: timestamp,
                    isAi: isAi,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1),
                  ),
                  AnswersList(answers: answers),
                  const SizedBox(height: 16),
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
          )
        ],
      ),
    );
  }
}