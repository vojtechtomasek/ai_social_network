import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';
import '../models/discussion_model.dart';

class SavedContentProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  List<PostModel> _savedPosts = [];
  List<DiscussionModel> _savedDiscussions = [];
  bool _isLoading = false;
  String? _error;
  
  List<PostModel> get savedPosts => _savedPosts;
  List<DiscussionModel> get savedDiscussions => _savedDiscussions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> fetchSavedPosts() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      
      final response = await _supabase
          .from('saved_posts')
          .select('''
            post_id,
            posts(
              *,
              users(*),
              ai_profiles(*)
            )
          ''')
          .eq('user_id', user.id)
          .not('post_id', 'is', null)
          .order('saved_at', ascending: false);
      
      _savedPosts = (response as List)
          .where((item) => item['posts'] != null)
          .map((item) => PostModel.fromJson(item['posts']))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchSavedDiscussions() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      
      final response = await _supabase
          .from('saved_posts')
          .select('''
            discussion_id,
            threads(
              *,
              users(*),
              ai_profiles(*)
            )
          ''')
          .eq('user_id', user.id)
          .not('discussion_id', 'is', null)
          .order('saved_at', ascending: false);
      
      _savedDiscussions = (response as List)
          .where((item) => item['threads'] != null)
          .map((item) => DiscussionModel.fromJson(item['threads']))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> savePost(String postId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;
    
    try {
      await _supabase
          .from('saved_posts')
          .insert({
            'user_id': user.id,
            'post_id': postId,
          });
      await fetchSavedPosts();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> saveDiscussion(String discussionId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;
    
    try {
      await _supabase
          .from('saved_posts')
          .insert({
            'user_id': user.id,
            'discussion_id': discussionId,
          });
      await fetchSavedDiscussions();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> unsavePost(String postId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;
    
    try {
      await _supabase
          .from('saved_posts')
          .delete()
          .eq('user_id', user.id)
          .eq('post_id', postId);
      await fetchSavedPosts();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> unsaveDiscussion(String discussionId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;
    
    try {
      await _supabase
          .from('saved_posts')
          .delete()
          .eq('user_id', user.id)
          .eq('discussion_id', discussionId);
      await fetchSavedDiscussions();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> isPostSaved(String postId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;
    
    try {
      final response = await _supabase
          .from('saved_posts')
          .select()
          .eq('user_id', user.id)
          .eq('post_id', postId);
      
      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> isDiscussionSaved(String discussionId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;
    
    try {
      final response = await _supabase
          .from('saved_posts')
          .select()
          .eq('user_id', user.id)
          .eq('discussion_id', discussionId);
      
      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}