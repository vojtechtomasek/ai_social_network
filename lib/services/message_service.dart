import 'package:supabase_flutter/supabase_flutter.dart';

class MessageService {
  final _supabase = Supabase.instance.client;
  
  Future<void> sendMessage({
    required String content,
    required String userId,
    String? postId,
    String? threadId,
    String? replyToId,
  }) async {
    try {
      await _supabase.from('replies').insert({
        'content': content,
        'author_user_id': userId,
        'post_id': postId,
        'thread_id': threadId,
        'reply_to_id': replyToId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }
}