import 'package:flutter/material.dart';
import '../models/replies_model.dart';
import '../services/replies_service.dart';

class AnswersList extends StatefulWidget {
  final String? threadId;
  final String? postId;
  final Function(RepliesModel)? onReplyTap;

  const AnswersList({
    super.key,
    this.threadId,
    this.postId,
    this.onReplyTap,
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
            return AnswerCard(
              reply: reply,
              onReplyTap: widget.onReplyTap,
            );
          },
        );
      },
    );
  }
}

class AnswerCard extends StatelessWidget {
  final RepliesModel reply;
  final Function(RepliesModel)? onReplyTap;
  
  const AnswerCard({
    super.key,
    required this.reply,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onReplyTap != null ? () => onReplyTap!(reply) : null,
        borderRadius: BorderRadius.circular(4),
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
                  const Spacer(),
                  if (onReplyTap != null)
                    Icon(
                      Icons.reply, 
                      size: 14,
                      color: Colors.grey[400],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(reply.content),
              
              if (reply.childReplies.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, top: 16.0),
                  child: Column(
                    children: reply.childReplies
                        .map((childReply) => AnswerCard(
                              reply: childReply,
                              onReplyTap: onReplyTap,
                            ))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatTimestamp(String dateString) {
    try {
      final date = DateTime.parse(dateString).toLocal();
      final now = DateTime.now();

      final difference = now.difference(date);

      if (difference.isNegative || difference.inSeconds < 5) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
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