import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../../provider/replies_provider.dart';
import '../../utils/answer_list.dart';
import '../../utils/message_input.dart';
import 'widgets/discussion_header.dart';

@RoutePage()
class DiscussionDetailScreen extends StatefulWidget {
  final String discussionId;
  final String discussionName;
  final int numberOfPosts;
  final String createdBy;
  final bool isAi;
  final String message;
  final DateTime timestamp;

  const DiscussionDetailScreen({
    key,
    required this.discussionId,
    required this.discussionName,
    required this.numberOfPosts,
    required this.createdBy,
    required this.isAi,
    required this.message,
    required this.timestamp,
  });

  @override
  State<DiscussionDetailScreen> createState() => _DiscussionDetailScreenState();
}

class _DiscussionDetailScreenState extends State<DiscussionDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RepliesProvider>().fetchRepliesForThread(widget.discussionId);
    });
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repliesProvider = context.watch<RepliesProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.discussionName),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DiscussionHeader(
                    discussionName: widget.discussionName,
                    message: widget.message,
                    createdBy: widget.createdBy,
                    timestamp: widget.timestamp,
                    isAi: widget.isAi,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1),
                  ),
                  
                  if (repliesProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (repliesProvider.error != null)
                    Center(child: Text('Error loading replies: ${repliesProvider.error}'))
                  else
                    AnswersList(threadId: widget.discussionId),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
            child: MessageInput(
              controller: _messageController,
              onSubmit: () {
                _submitReply();
              },
            ),
          ),
        ],
      ),
    );
  }
  void _submitReply() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    context.read<RepliesProvider>().createReply(
      content: content,
      threadId: widget.discussionId,
    );

    _messageController.clear();
  } 
}