import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> loadUserData() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception("User not authenticated");
    }

    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      return response;
    } catch (e) {
      throw Exception("Failed to load profile: ${e.toString()}");
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String userName,
    required String bio,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception("User not authenticated");
    }

    try {
      await _supabase.from('users').update({
        'first_name': firstName,
        'last_name': lastName,
        'user_name': userName,
        'bio': bio,
      }).eq('id', userId);
    } catch (e) {
      throw Exception("Failed to update profile: ${e.toString()}");
    }
  }
}