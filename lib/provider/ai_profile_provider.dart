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
      final response = await _supabase
          .from('ai_profiles')
          .select()
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
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await _supabase.from('ai_profiles').insert({
        'name': name,
        'personality': personality,
        'writing_style': writingStyle,
        'created_at': DateTime.now().toIso8601String(),
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

  Future<bool> deleteProfile(String profileId) async {
    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _supabase
          .from('ai_profiles')
          .delete()
          .eq('id', profileId);

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