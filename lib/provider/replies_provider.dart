import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/replies_model.dart';
import '../services/replies_service.dart';

class RepliesProvider extends ChangeNotifier {
  final ReplyService _replyService = ReplyService();
  final _supabase = Supabase.instance.client;
  
  final Map<String, List<RepliesModel>> _postReplies = {};
  final Map<String, bool> _hasMorePostReplies = {}; // Track if more replies exist for each post
  final Map<String, bool> _isLoadingMorePostReplies = {}; // Track loading state for each post

  final Map<String, List<RepliesModel>> _threadReplies = {};
  final Map<String, bool> _hasMoreThreadReplies = {}; // Track if more replies exist for each thread
  final Map<String, bool> _isLoadingMoreThreadReplies = {}; // Track loading state for each thread

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<RepliesModel> getRepliesForPost(String postId) => _postReplies[postId] ?? [];
  List<RepliesModel> getRepliesForThread(String threadId) => _threadReplies[threadId] ?? [];
  bool hasMoreRepliesForPost(String postId) => _hasMorePostReplies[postId] ?? true;
  bool isLoadingMoreRepliesForPost(String postId) => _isLoadingMorePostReplies[postId] ?? false;
  bool hasMoreRepliesForThread(String threadId) => _hasMoreThreadReplies[threadId] ?? true;
  bool isLoadingMoreRepliesForThread(String threadId) => _isLoadingMoreThreadReplies[threadId] ?? false;
  
  Future<void> fetchRepliesForPost(String postId, {bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _postReplies[postId] = [];
      _hasMorePostReplies[postId] = true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final offset = _postReplies[postId]?.length ?? 0;
      final replies = await _replyService.fetchPostReplies(postId, offset: offset);

      if (replies.isEmpty) {
        _hasMorePostReplies[postId] = false;
      } else {
        _postReplies[postId] = [...(_postReplies[postId] ?? []), ...replies];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreRepliesForPost(String postId) async {
    if (_isLoadingMorePostReplies[postId] == true || !hasMoreRepliesForPost(postId)) return;

    _isLoadingMorePostReplies[postId] = true;
    notifyListeners();

    try {
      final offset = _postReplies[postId]?.length ?? 0;
      final replies = await _replyService.fetchPostReplies(postId, offset: offset);

      if (replies.isEmpty) {
        _hasMorePostReplies[postId] = false;
      } else {
        _postReplies[postId] = [...(_postReplies[postId] ?? []), ...replies];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMorePostReplies[postId] = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchRepliesForThread(String threadId, {bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _threadReplies[threadId] = [];
      _hasMoreThreadReplies[threadId] = true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final offset = _threadReplies[threadId]?.length ?? 0;
      final replies = await _replyService.fetchThreadReplies(threadId, offset: offset);

      if (replies.isEmpty) {
        _hasMoreThreadReplies[threadId] = false;
      } else {
        _threadReplies[threadId] = [...(_threadReplies[threadId] ?? []), ...replies];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreRepliesForThread(String threadId) async {
    if (_isLoadingMoreThreadReplies[threadId] == true || !hasMoreRepliesForThread(threadId)) return;

    _isLoadingMoreThreadReplies[threadId] = true;
    notifyListeners();

    try {
      final offset = _threadReplies[threadId]?.length ?? 0;
      final replies = await _replyService.fetchThreadReplies(threadId, offset: offset);

      if (replies.isEmpty) {
        _hasMoreThreadReplies[threadId] = false;
      } else {
        _threadReplies[threadId] = [...(_threadReplies[threadId] ?? []), ...replies];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMoreThreadReplies[threadId] = false;
      notifyListeners();
    }
  }
  
  Future<void> createReply({
    required String content,
    String? postId,
    String? threadId,
    String? replyToId,
  }) async {
    
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }

    assert(postId != null || threadId != null, 'Either postId or threadId must be provided');

    try {
      final userProfiles = await _supabase
          .from('users')
          .select('first_name, last_name, user_name')
          .eq('id', user.id)
          .single();

      String authorName;
      final firstName = userProfiles['first_name'] ?? '';
      final lastName = userProfiles['last_name'] ?? '';
      authorName = '$firstName $lastName'.trim();

      if (authorName.isEmpty) {
        authorName = userProfiles['user_name'] ?? 'Unknown User';
      }

      final response = await _supabase.from('replies').insert({
        'content': content,
        'author_user_id': user.id,
        'post_id': postId,
        'thread_id': threadId,
        'reply_to_id': replyToId,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      final newReply = RepliesModel(
        id: response['id'],
        authorUserId: user.id,
        content: content,
        postId: postId,
        threadId: threadId,
        replyToId: replyToId,
        createdAt: response['created_at'],
        authorName: authorName,
        isAiAuthor: false,
        childReplies: [],
      );

      if (postId != null) {
        if (replyToId == null) {
          _postReplies[postId] = [newReply, ...(_postReplies[postId] ?? [])];
        } else {
          _addChildReply(postId, replyToId, newReply);
        }
      } else if (threadId != null) {
        if (replyToId == null) {
          _threadReplies[threadId] = [newReply, ...(_threadReplies[threadId] ?? [])];
        } else {
          _addChildReply(threadId, replyToId, newReply, isThread: true);
        }
      }

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _addChildReply(String contentId, String parentReplyId, RepliesModel newReply, {bool isThread = false}) {
    final replies = isThread ? _threadReplies[contentId] : _postReplies[contentId];
    if (replies == null) return;

    for (int i = 0; i < replies.length; i++) {
      if (replies[i].id == parentReplyId) {
        final updatedParent = replies[i].copyWith(
          childReplies: [newReply, ...replies[i].childReplies]
        );

        final updatedReplies = List<RepliesModel>.from(replies);
        updatedReplies[i] = updatedParent;

        if (isThread) {
          _threadReplies[contentId] = updatedReplies;
        } else {
          _postReplies[contentId] = updatedReplies;
        }
        return;
      }

      _findAndAddToChildReplies(replies, i, parentReplyId, newReply);
    }
  }

  bool _findAndAddToChildReplies(List<RepliesModel> replies, int parentIndex, String targetReplyId, RepliesModel newReply) {
    final childReplies = replies[parentIndex].childReplies;

    for (int i = 0; i < childReplies.length; i++) {
      if (childReplies[i].id == targetReplyId) {
        final updatedChildren = List<RepliesModel>.from(childReplies);
        updatedChildren[i] = childReplies[i].copyWith(
          childReplies: [newReply, ...childReplies[i].childReplies]
        );

        replies[parentIndex] = replies[parentIndex].copyWith(
          childReplies: updatedChildren
        );

        return true;
      }

      if (_findAndAddToChildReplies(childReplies, i, targetReplyId, newReply)) {
        replies[parentIndex] = replies[parentIndex].copyWith(
          childReplies: childReplies
        );
        return true;
      }
    }

    return false;
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


Future<void> fetchRepliesForParent(String parentReplyId) async {
  if (_isLoading) return;
  
  
  try {
    final childReplies = await _replyService.fetchNestedReplies(parentReplyId);
    
    for (final postId in _postReplies.keys) {
      _updateReplyChildrenInList(
        _postReplies[postId]!, 
        parentReplyId, 
        childReplies
      );
    }
    
    for (final threadId in _threadReplies.keys) {
      _updateReplyChildrenInList(
        _threadReplies[threadId]!, 
        parentReplyId, 
        childReplies
      );
    }
    
    notifyListeners();
  } catch (e) {
    print('Error fetching child replies: $e');
  }
}

bool _updateReplyChildrenInList(List<RepliesModel> replies, String parentReplyId, List<RepliesModel> childReplies) {
  for (int i = 0; i < replies.length; i++) {
    if (replies[i].id == parentReplyId) {
      replies[i] = replies[i].copyWith(childReplies: childReplies);
      return true;
    }
    
    if (_updateReplyChildrenInList(replies[i].childReplies, parentReplyId, childReplies)) {
      return true;
    }
  }
  
  return false;
}
}