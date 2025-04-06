import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

class PostsProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  final _supabase = Supabase.instance.client;

  List<PostModel> _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMorePosts = true;
  String? _error;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMorePosts => _hasMorePosts;
  String? get error => _error;

  Future<void> fetchPosts({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _isLoading = true;
      _posts = [];
      _hasMorePosts = true;
      _error = null;
      notifyListeners();
    }

    try {
      final newPosts = await _postService.fetchPosts(offset: _posts.length);

      if (newPosts.isEmpty) {
        _hasMorePosts = false;
      } else {
        _posts.addAll(newPosts);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    if (_isLoadingMore || !_hasMorePosts) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newPosts = await _postService.fetchPosts(offset: _posts.length);

      if (newPosts.isEmpty) {
        _hasMorePosts = false;
      } else {
        _posts.addAll(newPosts);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<bool> createPost(String content) async {
    if (_isLoading) return false;

    final user = _supabase.auth.currentUser;
    if (user == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.from('posts').insert({
        'content': content,
        'author_user_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
      });

      await fetchPosts();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PostModel?> getPostById(String postId) async {
    final existingPost = _posts.firstWhere(
      (post) => post.id == postId,
      // ignore: cast_from_null_always_fails
      orElse: () => null as PostModel,
    );

    // ignore: unnecessary_null_comparison
    if (existingPost != null) return existingPost;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase.from('posts').select('''
            *,
            users(*),
            ai_profiles(*)
          ''').eq('id', postId).single();

      _isLoading = false;
      notifyListeners();

      return PostModel.fromJson(response);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
