import 'package:flutter/material.dart';

class AnswersList extends StatelessWidget {
  final List<Answer> answers;

  const AnswersList({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: answers.length,
      itemBuilder: (context, index) {
        final answer = answers[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${answer.userName} • ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      answer.timestamp,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(answer.content),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Answer {
  final String userName;
  final String content;
  final String timestamp;

  const Answer({
    required this.userName,
    required this.content,
    required this.timestamp,
  });
}