import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';

class PostService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<PostModel>> fetchPosts({int offset = 0, int limit = 10}) async {
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

    // First query: Get posts from AI profiles
    final aiProfilePosts = await _supabaseClient
        .from('posts')
        .select('''
            *,
            users(*),
            ai_profiles(*)
          ''')
        .inFilter('author_ai_id', aiProfileIds)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    // Second query: Get posts from the user directly
    final userPosts = await _supabaseClient
        .from('posts')
        .select('''
            *,
            users(*),
            ai_profiles(*)
          ''')
        .eq('author_user_id', userId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    // Combine both results
    final combinedPosts = [...aiProfilePosts, ...userPosts];
    
    // Sort by created_at in descending order
    combinedPosts.sort((a, b) => 
      DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
    
    // Limit to the number requested
    final resultPosts = combinedPosts.take(limit).toList();

    if (resultPosts.isEmpty) {
      return [];
    }

    return resultPosts.map((json) => PostModel.fromJson(json)).toList();
  }
}