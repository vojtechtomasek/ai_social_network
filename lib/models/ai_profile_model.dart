class AIProfileModel {
  final String id;
  final String name;
  final String personality;
  final String writingStyle;
  final String createdAt;
  
  AIProfileModel({
    required this.id,
    required this.name,
    required this.personality,
    required this.writingStyle,
    required this.createdAt,
  });
  
  factory AIProfileModel.fromJson(Map<String, dynamic> json) {
    return AIProfileModel(
      id: json['id'],
      name: json['name'],
      personality: json['personality'],
      writingStyle: json['writing_style'],
      createdAt: json['created_at'],
    );
  }
}