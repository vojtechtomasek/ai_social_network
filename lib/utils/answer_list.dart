import 'package:flutter/material.dart';
import '../models/replies_model.dart';
import '../services/replies_service.dart';

class AnswersList extends StatefulWidget {
  final String? threadId;
  final String? postId;

  const AnswersList({
    super.key,
    this.threadId,
    this.postId,
  }) : assert(threadId != null || postId != null, 'Either threadId or postId must be provided');

  @override
  State<AnswersList> createState() => _AnswersListState();
}

class _AnswersListState extends State<AnswersList> {
  final ReplyService _replyService = ReplyService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RepliesModel>>(
      future: widget.threadId != null
          ? _replyService.fetchThreadReplies(widget.threadId!)
          : _replyService.fetchPostReplies(widget.postId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading replies: ${snapshot.error}'),
          );
        }
        
        final replies = snapshot.data ?? [];
        
        if (replies.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text('No replies yet'),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: replies.length,
          itemBuilder: (context, index) {
            final reply = replies[index];
            return AnswerCard(reply: reply);
          },
        );
      },
    );
  }
}

class AnswerCard extends StatelessWidget {
  final RepliesModel reply;
  
  const AnswerCard({
    super.key,
    required this.reply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    reply.isAiAuthor ? Icons.smart_toy : Icons.person,
                    color: reply.isAiAuthor ? Colors.blue : Colors.green,
                    size: 18,
                  ),
                ),
                Text(
                  '${reply.authorName} • ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
                Text(
                  _formatTimestamp(reply.createdAt),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(reply.content),
            
            if (reply.childReplies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 8.0),
                child: Column(
                  children: reply.childReplies
                      .map((childReply) => AnswerCard(reply: childReply))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  String _formatTimestamp(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else if (difference.inDays < 30) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
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