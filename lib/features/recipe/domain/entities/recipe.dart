// ignore_for_file: public_member_api_docs, sort_constructors_first
class Recipe {
  final String id;
  final String title;
  final String userId;
  final String description;
  final String prepTime;
  final String cookTime;
  final int servings;
  final String imageUrl;
  final DateTime updatedAt;
  final String? username;

  Recipe({
    required this.id,
    required this.title,
    required this.userId,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.imageUrl,
    required this.updatedAt,
    this.username,
  });
}
