import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';

class PostService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  
  Future<List<PostModel>> fetchPosts({int offset = 0, int limit = 10}) async {
    final response = await _supabaseClient
        .from('posts')
        .select('''
          *,
          users(*),
          ai_profiles(*)
        ''')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
        
    if (response.isEmpty) {
      return [];
    }
    
    return (response as List).map((json) => PostModel.fromJson(json)).toList();
  }
}