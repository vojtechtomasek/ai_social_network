import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../../provider/replies_provider.dart';
import '../../utils/answer_list.dart';
import '../../utils/message_input.dart';

@RoutePage()
class PostDetailScreen extends StatefulWidget {
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
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RepliesProvider>().fetchRepliesForPost(widget.postId);
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
        title: Text('Message from ${widget.sender}'),
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
                          widget.isAi ? Icons.smart_toy : Icons.person,
                          color: widget.isAi ? Colors.blue : Colors.green,
                          size: 18,
                        ),
                      ),
                      Text(
                        widget.sender,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.timestamp.toLocal()}'.split(' ')[0],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(widget.message),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1),
                  ),
                  
                  if (repliesProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (repliesProvider.error != null)
                    Center(child: Text('Error loading replies: ${repliesProvider.error}'))
                  else
                    AnswersList(postId: widget.postId),
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
      postId: widget.postId,
    );
    
    _messageController.clear();
  }
}