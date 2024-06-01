class Recipe {
  final String id;
  final String? name;
  final String userId;
  final String? description;
  final String? prepTime;
  final String? cookTime;
  final String? servings;
  final List<String> ingredients;
  final String? imageUrl;
  final DateTime updatedAt;
  final String? directions;
  final String? notes;
  final String? sources;
  final String? utensils;
  final bool? public;
  final String? userName;

  Recipe({
    required this.id,
    this.name,
    required this.userId,
    this.description,
    this.prepTime,
    this.cookTime,
    this.servings,
    required this.ingredients,
    this.imageUrl,
    required this.updatedAt,
    this.directions,
    this.notes,
    this.sources,
    this.utensils,
    this.public,
    this.userName,
  });
}
