class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String userName;
  final String bio;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.userName = '',
    this.bio = '',
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  // Convert model to a map for Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create a model from Supabase data
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      userName: map['user_name'] ?? '',
      bio: map['bio'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }
}