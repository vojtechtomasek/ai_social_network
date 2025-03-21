import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/replies_model.dart';
import '../services/replies_service.dart';

class RepliesProvider extends ChangeNotifier {
  final ReplyService _replyService = ReplyService();
  final _supabase = Supabase.instance.client;
  
  final Map<String, List<RepliesModel>> _postReplies = {};
  final Map<String, List<RepliesModel>> _threadReplies = {};
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<RepliesModel> getRepliesForPost(String postId) => 
      _postReplies[postId] ?? [];
      
  List<RepliesModel> getRepliesForThread(String threadId) => 
      _threadReplies[threadId] ?? [];
  
  Future<void> fetchRepliesForPost(String postId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final replies = await _replyService.fetchPostReplies(postId);
      _postReplies[postId] = replies;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchRepliesForThread(String threadId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final replies = await _replyService.fetchThreadReplies(threadId);
      _threadReplies[threadId] = replies;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> createReply({
    required String content,
    String? postId,
    String? threadId,
    String? replyToId,
  }) async {
    if (_isLoading) return;
    
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }
    
    assert(postId != null || threadId != null, 
      'Either postId or threadId must be provided');
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await _supabase.from('replies').insert({
        'content': content,
        'author_user_id': user.id,
        'post_id': postId,
        'thread_id': threadId,
        'reply_to_id': replyToId,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      if (postId != null) {
        await fetchRepliesForPost(postId);
      } else if (threadId != null) {
        await fetchRepliesForThread(threadId);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> sendMessage({
    required String content,
    String? postId,
    String? threadId,
    String? replyToId,
  }) async {
    try {
      await createReply(
        content: content,
        postId: postId,
        threadId: threadId,
        replyToId: replyToId,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}