import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/replies_model.dart';
import '../provider/replies_provider.dart';
import 'answer_card.dart';

class AnswersList extends StatelessWidget {
  final String? threadId;
  final String? postId;
  final Function(RepliesModel)? onReplyTap;

  const AnswersList({
    super.key,
    this.threadId,
    this.postId,
    this.onReplyTap,
  }) : assert(threadId != null || postId != null,
            'Either threadId or postId must be provided');

  @override
  Widget build(BuildContext context) {
    final repliesProvider = context.watch<RepliesProvider>();
    final replies = postId != null
        ? repliesProvider.getRepliesForPost(postId!)
        : repliesProvider.getRepliesForThread(threadId!);

    final hasMore = postId != null
        ? repliesProvider.hasMoreRepliesForPost(postId!)
        : repliesProvider.hasMoreRepliesForThread(threadId!);

    final isLoadingMore = postId != null
        ? repliesProvider.isLoadingMoreRepliesForPost(postId!)
        : repliesProvider.isLoadingMoreRepliesForThread(threadId!);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            !isLoadingMore &&
            hasMore) {
          if (postId != null) {
            repliesProvider.loadMoreRepliesForPost(postId!);
          } else if (threadId != null) {
            repliesProvider.loadMoreRepliesForThread(threadId!);
          }
          return true;
        }
        return false;
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: ListView.builder(
          itemCount: replies.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= replies.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final reply = replies[index];
            return AnswerCard(reply: reply, onReplyTap: onReplyTap);
          },
        ),
      ),
    );
  }
}