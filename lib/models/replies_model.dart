class RepliesModel {
  final String id;
  final String? authorUserId;
  final String? authorAiId;
  final String content;
  final String? postId;
  final String? threadId;
  final String? replyToId;
  final String createdAt;
  final String authorName;
  final bool isAiAuthor;
  final List<RepliesModel> childReplies;

  RepliesModel({
    required this.id,
    this.authorUserId,
    this.authorAiId,
    required this.content,
    this.postId,
    this.threadId,
    this.replyToId,
    required this.createdAt,
    required this.authorName,
    required this.isAiAuthor,
    this.childReplies = const [],
  });

  factory RepliesModel.fromJson(Map<String, dynamic> json, {List<RepliesModel> childReplies = const []}) {
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

    return RepliesModel(
      id: json['id'] ?? '',
      authorUserId: json['author_user_id'],
      authorAiId: json['author_ai_id'],
      content: json['content'] ?? '',
      postId: json['post_id'],
      threadId: json['thread_id'],
      replyToId: json['reply_to_id'],
      createdAt: json['created_at'] ?? '',
      authorName: authorName,
      isAiAuthor: isAiAuthor,
      childReplies: childReplies,
    );
  }
}