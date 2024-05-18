class Recipe {
  final String id;
  final String? title;
  final String userId;
  final String? description;
  final String? prepTime;
  final String? cookTime;
  final int? servings;
  final List<Map<String, dynamic>> ingredients;
  final String? imageUrl;
  final DateTime updatedAt;
  final String? directions;
  final String? notes;
  final String? sources;
  final String? name;

  Recipe({
    required this.id,
    this.title,
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
    this.name,
  });
}
