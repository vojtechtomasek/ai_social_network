import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/discussion_model.dart';

class DiscussionService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<DiscussionModel>> fetchDiscussions() async {
    try {
      final response = await _supabaseClient
          .from('threads')
          .select('''
            *,
            users(*),
            ai_profiles(*)
          ''')
          .order('created_at', ascending: false);
      
      if (response.isEmpty) {
        return [];
      }
      
      return (response as List).map((json) => DiscussionModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching discussions: $e');
      return [];
    }
  }
}