import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/replies_model.dart';

class ReplyService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<RepliesModel>> fetchPostReplies(String postId,
      {int offset = 0, int limit = 10}) async {
    return _fetchReplies(postId: postId, offset: offset, limit: limit);
  }

  Future<List<RepliesModel>> fetchThreadReplies(String threadId,
      {int offset = 0, int limit = 10}) async {
    return _fetchReplies(threadId: threadId, offset: offset, limit: limit);
  }

  Future<List<RepliesModel>> fetchNestedReplies(String replyId) async {
    return _fetchReplies(replyToId: replyId);
  }

  Future<List<RepliesModel>> _fetchReplies({
    String? postId,
    String? threadId,
    String? replyToId,
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        return [];
      }

      final aiProfilesResponse = await _supabase
          .from('ai_profiles')
          .select('id')
          .eq('user_id', userId);

      // ignore: unnecessary_null_comparison
      if (aiProfilesResponse == null) {
        return [];
      }

      final aiProfileIds = (aiProfilesResponse as List)
          .map((profile) => profile['id'] as String)
          .toList();

      // Build the base filter conditions based on what type of replies we're fetching
      String filterCondition = '';
      if (postId != null) {
        filterCondition = "post_id.eq.$postId";
        if (replyToId == null) {
          filterCondition += ",reply_to_id.is.null";
        }
      } else if (threadId != null) {
        filterCondition = "thread_id.eq.$threadId";
        if (replyToId == null) {
          filterCondition += ",reply_to_id.is.null";
        }
      } else if (replyToId != null) {
        filterCondition = "reply_to_id.eq.$replyToId";
      }

      // First query: Get replies from AI profiles
      final aiReplies = await _supabase
          .from('replies')
          .select('''
            *,
            users(*),
            ai_profiles(*)
          ''')
          .inFilter('author_ai_id', aiProfileIds)
          .or(filterCondition)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      // Second query: Get replies from the user directly
      final userReplies = await _supabase
          .from('replies')
          .select('''
            *,
            users(*),
            ai_profiles(*)
          ''')
          .eq('author_user_id', userId)
          .or(filterCondition)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      // Combine both results
      final combinedReplies = [...aiReplies, ...userReplies];
      
      // Sort by created_at in descending order
      combinedReplies.sort((a, b) => 
        DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
      
      // Limit to the number requested
      final resultReplies = combinedReplies.take(limit).toList();

      return resultReplies
          .map((item) => RepliesModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching replies: $e');
      return [];
    }
  }

  // Rest of the code remains unchanged
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