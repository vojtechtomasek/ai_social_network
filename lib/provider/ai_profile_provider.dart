import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ai_profile_model.dart';

class AIProfileProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  List<AIProfileModel> _profiles = [];
  bool _isLoading = false;
  String? _error;
  
  List<AIProfileModel> get profiles => _profiles;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> fetchProfiles() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        _error = 'User not authenticated';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _supabase
          .from('ai_profiles')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      _profiles = (response as List).map((data) => AIProfileModel.fromJson(data)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createAIProfile({
    required String name,
    required String personality,
    required String writingStyle,
  }) async {
    if (_isLoading) return false;
    
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();
    
    try {
      await _supabase.from('ai_profiles').insert({
        'name': name,
        'personality': personality,
        'writing_style': writingStyle,
        'created_at': DateTime.now().toIso8601String(),
        'user_id': userId,
      });
      
      await fetchProfiles();
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

  Future<bool> updateAIProfile({
    required String profileId,
    required String name,
    required String personality,
    required String writingStyle,
  }) async {
    if (_isLoading) return false;

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabase
          .from('ai_profiles')
          .update({
            'name': name,
            'personality': personality,
            'writing_style': writingStyle,
          })
          .eq('id', profileId)
          .eq('user_id', userId);

      final index = _profiles.indexWhere((profile) => profile.id == profileId);
      if (index >= 0) {
        _profiles[index] = AIProfileModel(
          id: profileId,
          name: name,
          personality: personality,
          writingStyle: writingStyle,
          createdAt: _profiles[index].createdAt,
          userId: _profiles[index].userId,
        );
      }

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

  Future<bool> deleteProfile(String profileId) async {
    if (_isLoading) return false;

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _supabase
          .from('ai_profiles')
          .delete()
          .eq('id', profileId)
          .eq('user_id', userId);

      _profiles.removeWhere((profile) => profile.id == profileId);
      notifyListeners();
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
}