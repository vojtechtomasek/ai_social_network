import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

class PostsProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  final _supabase = Supabase.instance.client;
  
  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _error;
  
  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> fetchPosts() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _posts = await _postService.fetchPosts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> createPost(String content) async {
    if (_isLoading) return;
    
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
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
    } catch (e) {
      _error = e.toString();
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
      final response = await _supabase
          .from('posts')
          .select('''
            *,
            users(*),
            ai_profiles(*)
          ''')
          .eq('id', postId)
          .single();
      
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