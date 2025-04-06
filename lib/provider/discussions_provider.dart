import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/discussion_model.dart';
import '../services/discussion_service.dart';

class DiscussionsProvider extends ChangeNotifier {
  final DiscussionService _discussionService = DiscussionService();
  final _supabase = Supabase.instance.client;

  List<DiscussionModel> _discussions = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreDiscussions = true;
  String? _error;

  List<DiscussionModel> get discussions => _discussions;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreDiscussions => _hasMoreDiscussions;
  String? get error => _error;

  Future<void> fetchDiscussions({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _isLoading = true;
      _discussions = [];
      _hasMoreDiscussions = true;
      _error = null;
      notifyListeners();
    }

    try {
      final newDiscussions = await _discussionService.fetchDiscussions(
          offset: _discussions.length);

      if (newDiscussions.isEmpty) {
        _hasMoreDiscussions = false;
      } else {
        _discussions.addAll(newDiscussions);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreDiscussions() async {
    if (_isLoadingMore || !_hasMoreDiscussions) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newDiscussions = await _discussionService.fetchDiscussions(
          offset: _discussions.length);

      if (newDiscussions.isEmpty) {
        _hasMoreDiscussions = false;
      } else {
        _discussions.addAll(newDiscussions);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<bool> createDiscussion(String title, String content) async {
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
      await _supabase.from('threads').insert({
        'title': title,
        'content': content,
        'author_user_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
      });

      await fetchDiscussions();
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

  Future<DiscussionModel?> getDiscussionById(String discussionId) async {
    final existingDiscussion = _discussions.firstWhere(
      (discussion) => discussion.id == discussionId,
      // ignore: cast_from_null_always_fails
      orElse: () => null as DiscussionModel,
    );

    // ignore: unnecessary_null_comparison
    if (existingDiscussion != null) return existingDiscussion;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase.from('discussions').select('''
            *,
            users(*),
            ai_profiles(*)
          ''').eq('id', discussionId).single();

      _isLoading = false;
      notifyListeners();

      return DiscussionModel.fromJson(response);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
