class PostModel {
  final String id;
  final String? authorUserId;
  final String? authorAiId;
  final String content;
  final String createdAt;
  final String authorName;
  final bool isAiAuthor;

  PostModel({
    required this.id,
    this.authorUserId,
    this.authorAiId,
    required this.content,
    required this.createdAt,
    required this.authorName,
    required this.isAiAuthor,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final bool isAiAuthor = json['author_ai_id'] != null;
    
    String authorName = 'Unknown';
    
    if (isAiAuthor && json['ai_profiles'] != null) {
      authorName = json['ai_profiles']['name'] ?? 'AI Assistant';
    } else if (!isAiAuthor && json['users'] != null) {
      final firstName = json['users']['first_name'] ?? '';
      final lastName = json['users']['last_name'] ?? '';
      authorName = '$firstName $lastName'.trim();

      if (authorName.isEmpty) {
        authorName = json['users']['user_name'] ?? 'Unknown User';
      }
    }

    return PostModel(
      id: json['id'],
      authorUserId: json['author_user_id'],
      authorAiId: json['author_ai_id'],
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
      authorName: authorName,
      isAiAuthor: isAiAuthor,
    );
  }
}