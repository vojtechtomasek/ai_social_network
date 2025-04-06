import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/replies_model.dart';
import '../provider/replies_provider.dart';

class AnswerCard extends StatefulWidget {
  final RepliesModel reply;
  final Function(RepliesModel)? onReplyTap;

  const AnswerCard({
    super.key,
    required this.reply,
    this.onReplyTap,
  });

  @override
  State<AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  bool _expanded = false;
  bool _loadingReplies = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: widget.onReplyTap != null
            ? () => widget.onReplyTap!(widget.reply)
            : null,
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
                      widget.reply.isAiAuthor ? Icons.smart_toy : Icons.person,
                      color:
                          widget.reply.isAiAuthor ? Colors.blue : Colors.green,
                      size: 18,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${widget.reply.authorName} • ${_formatTimestamp(widget.reply.createdAt)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.onReplyTap != null)
                    Icon(
                      Icons.reply,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.reply.content),
              if (widget.reply.childReplies.isNotEmpty && !_expanded)
                InkWell(
                  onTap: _toggleExpanded,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.forum_outlined,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.reply.childReplies.length} ${widget.reply.childReplies.length == 1 ? 'reply' : 'replies'}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_expanded)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    if (_loadingReplies)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, top: 8.0),
                        child: Column(
                          children: widget.reply.childReplies
                              .map((childReply) => AnswerCard(
                                    reply: childReply,
                                    onReplyTap: widget.onReplyTap,
                                  ))
                              .toList(),
                        ),
                      ),
                    InkWell(
                      onTap: _toggleExpanded,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.unfold_less,
                              size: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Hide replies',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;

      if (_expanded && widget.reply.childReplies.isEmpty) {
        _loadReplies();
      }
    });
  }

  Future<void> _loadReplies() async {
    setState(() {
      _loadingReplies = true;
    });

    try {
      if (widget.reply.childReplies.isEmpty) {
        final repliesProvider = context.read<RepliesProvider>();
        await repliesProvider.fetchRepliesForParent(widget.reply.id);
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingReplies = false;
        });
      }
    }
  }

  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}