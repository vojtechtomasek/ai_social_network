import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/user_profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  final _userProfileService = UserProfileService();
  
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _error;
  
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadUserData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _userData = await _userProfileService.loadUserData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String userName,
    required String bio,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _userProfileService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        userName: userName,
        bio: bio,
      );
      
      // Refresh the user data after update
      await loadUserData();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }
}