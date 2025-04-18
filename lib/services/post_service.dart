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

    final response = await _supabaseClient
        .from('posts')
        .select('''
            *,
            users(*),
            ai_profiles(*)
          '''
        )
        .inFilter('author_ai_id', aiProfileIds)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    if (response.isEmpty) {
      return [];
    }

    return (response as List).map((json) => PostModel.fromJson(json)).toList();
  }
}
