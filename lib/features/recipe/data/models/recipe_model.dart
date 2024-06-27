import 'package:evercook/features/recipe/domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  RecipeModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.description,
    required super.prepTime,
    required super.cookTime,
    required super.servings,
    required super.ingredients,
    required super.imageUrl,
    required super.updatedAt,
    required super.directions,
    required super.notes,
    required super.sources,
    required super.utensils,
    required super.public,
    super.userName,
  });

  RecipeModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? prepTime,
    String? cookTime,
    String? servings,
    List<String>? ingredients,
    String? imageUrl,
    DateTime? updatedAt,
    String? directions,
    String? notes,
    String? sources,
    String? utensils,
    bool? public,
    String? userName,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      ingredients: ingredients ?? this.ingredients,
      imageUrl: imageUrl ?? this.imageUrl,
      directions: directions ?? this.directions,
      notes: notes ?? this.notes,
      sources: sources ?? this.sources,
      utensils: utensils ?? this.utensils,
      public: public ?? this.public,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'prep_time': prepTime,
      'cook_time': cookTime,
      'servings': servings,
      'ingredients': ingredients,
      'image_url': imageUrl,
      'directions': directions,
      'notes': notes,
      'sources': sources,
      'utensils': utensils,
      'public': public,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory RecipeModel.fromJson(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String?,
      description: map['description'] as String?,
      prepTime: map['prep_time'] as String?,
      cookTime: map['cook_time'] as String?,
      servings: map['servings'] as String?,
      ingredients: _parseIngredients(map['ingredients']),
      imageUrl: map['image_url'] as String?,
      directions: map['directions'] as String?,
      notes: map['notes'] as String?,
      sources: map['sources'] as String?,
      utensils: map['utensils'] as String?,
      public: map['public'] as bool?,
      updatedAt: map['updated_at'] == null ? DateTime.now() : DateTime.parse(map['updated_at'] as String),
    );
  }

// Modify _parseIngredients to return a List<String>
  static List<String> _parseIngredients(dynamic ingredients) {
    if (ingredients is List) {
      // Assuming each ingredient is currently a simple string
      return List<String>.from(ingredients.map((dynamic item) => item.toString()));
    }
    // Return an empty list if ingredients are not in the expected format or null
    return [];
  }

  @override
  String toString() {
    return 'Recipe(id: $id, name: $name, user_id: $userId, description: $description, prep_time: $prepTime, cook_time: $cookTime, servings: $servings, ingredients: $ingredients, image_url: $imageUrl, directions: $directions, notes: $notes, sources: $sources, utensils: $utensils, public: $public, updated_at: $updatedAt), username: $userName';
  }
}
