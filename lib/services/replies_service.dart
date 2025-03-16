import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/replies_model.dart';

class ReplyService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<RepliesModel>> fetchPostReplies(String postId) async {
    return _fetchReplies(postId: postId);
  }

  Future<List<RepliesModel>> fetchThreadReplies(String threadId) async {
    return _fetchReplies(threadId: threadId);
  }

  Future<List<RepliesModel>> fetchNestedReplies(String replyId) async {
    return _fetchReplies(replyToId: replyId);
  }

  // Internal method to fetch replies based on parameters
  Future<List<RepliesModel>> _fetchReplies({
    String? postId,
    String? threadId,
    String? replyToId,
  }) async {
    try {
      // Create base query
      final query = _supabase.from('replies').select('''
        *,
        users(*),
        ai_profiles(*)
      ''');

      PostgrestFilterBuilder filteredQuery;

     if (postId != null) {
       filteredQuery = query
         .eq('post_id', postId)
         .filter('reply_to_id', 'is', null);
     } else if (threadId != null) {
       filteredQuery = query
         .eq('thread_id', threadId)
         .filter('reply_to_id', 'is', null);
     } else if (replyToId != null) {
       filteredQuery = query.eq('reply_to_id', replyToId);
     } else {
       filteredQuery = query;
     }

      final response = await filteredQuery.order('created_at', ascending: true);

      final List<RepliesModel> replies = [];

      for (var item in response) {
        final childReplies = await fetchNestedReplies(item['id']);
        replies.add(RepliesModel.fromJson(item, childReplies: childReplies));
      }

      return replies;
    } catch (e) {
      print('Error fetching replies: $e');
      return [];
    }
  }

  Future<void> createPostReply({
    required String postId,
    required String content,
    required String authorId,
    String? replyToId,
    bool isAiAuthor = false,
  }) async {
    await _createReply(
      content: content,
      authorId: authorId,
      postId: postId,
      replyToId: replyToId,
      isAiAuthor: isAiAuthor,
    );
  }

  Future<void> createThreadReply({
    required String threadId,
    required String content,
    required String authorId,
    String? replyToId,
    bool isAiAuthor = false,
  }) async {
    await _createReply(
      content: content,
      authorId: authorId,
      threadId: threadId,
      replyToId: replyToId,
      isAiAuthor: isAiAuthor,
    );
  }

  Future<void> _createReply({
    required String content,
    required String authorId,
    String? postId,
    String? threadId,
    String? replyToId,
    bool isAiAuthor = false,
  }) async {
    try {
      await _supabase.from('replies').insert({
        'content': content,
        'author_user_id': isAiAuthor ? null : authorId,
        'author_ai_id': isAiAuthor ? authorId : null,
        'post_id': postId,
        'thread_id': threadId,
        'reply_to_id': replyToId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error creating reply: $e');
      rethrow;
    }
  }
}