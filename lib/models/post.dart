
class AddPost{
  final String title;
  final String description;
  final String imagePath;
  final String createdAt;
  final String userId;
  final String categoryId;

  AddPost({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.createdAt,
    required this.userId,
    required this.categoryId,
  });

  // Convert a Post instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image_path': imagePath,
      'created_at': createdAt,
      'user_id': userId,
      'category_id': categoryId,
    };
  }

  // A Post instance from a JSON map
  factory AddPost.fromJson(Map<String, dynamic> json) {
    return AddPost(
      title: json['title'],
      description: json['description'],
      imagePath: json['image_path'],
      createdAt: json['created_at'],
      userId: json['user_id'],
      categoryId: json['category_id'],
    );
  } 
  
}