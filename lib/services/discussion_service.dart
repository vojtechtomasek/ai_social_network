import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/discussion_model.dart';

class DiscussionService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<DiscussionModel>> fetchDiscussions(
      {int offset = 0, int limit = 10}) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      return [];
    }

    final aiProfilesResponse = await _supabaseClient
        .from('ai_profiles')
        .select('id')
        .eq('user_id', userId);

    // ignore: unnecessary_null_comparison
    if (aiProfilesResponse == null) {
      return [];
    }

    final aiProfileIds = (aiProfilesResponse as List)
        .map((profile) => profile['id'] as String)
        .toList();

    try {
      // First query: Get discussions from AI profiles
      final aiProfileDiscussions = await _supabaseClient
          .from('threads')
          .select('''
              *,
              users(*),
              ai_profiles(*)
            ''')
          .inFilter('author_ai_id', aiProfileIds)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      // Second query: Get discussions from the user directly
      final userDiscussions = await _supabaseClient
          .from('threads')
          .select('''
              *,
              users(*),
              ai_profiles(*)
            ''')
          .eq('author_user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      // Combine both results
      final combinedDiscussions = [...aiProfileDiscussions, ...userDiscussions];
      
      // Sort by created_at in descending order
      combinedDiscussions.sort((a, b) => 
        DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
      
      // Limit to the number requested
      final resultDiscussions = combinedDiscussions.take(limit).toList();

      if (resultDiscussions.isEmpty) {
        return [];
      }

      return resultDiscussions.map((json) => DiscussionModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching discussions: $e');
      return [];
    }
  }
}