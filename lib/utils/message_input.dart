import 'package:flutter/material.dart';
import '../models/replies_model.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final RepliesModel? replyingTo;
  final VoidCallback? onCancelReply;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.replyingTo,
    this.onCancelReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (replyingTo != null)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
                left: BorderSide(color: Colors.grey.shade300),
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.reply, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Replying to ${replyingTo!.authorName}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: onCancelReply,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: replyingTo != null 
                      ? 'Reply to ${replyingTo!.authorName}...'
                      : 'Write a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                minLines: 1,
                maxLines: 4,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }
}