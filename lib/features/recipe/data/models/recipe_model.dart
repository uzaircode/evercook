import 'package:evercook/features/recipe/domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  RecipeModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.prepTime,
    required super.cookTime,
    required super.servings,
    required super.imageUrl,
    required super.updatedAt,
    super.username,
  });

  RecipeModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? prepTime,
    String? cookTime,
    int? servings,
    String? imageUrl,
    DateTime? updatedAt,
    String? username,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'prep_time': prepTime,
      'cook_time': cookTime,
      'servings': servings,
      'image_url': imageUrl,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory RecipeModel.fromJson(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      prepTime: map['prep_time'] as String,
      cookTime: map['cook_time'] as String,
      servings: map['servings'] as int,
      imageUrl: map['image_url'] as String,
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(
              map['updated_at'],
            ),
    );
  }

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, user_id: $userId, description: $description, prep_time: $prepTime, cook_time: $cookTime, servings: $servings, image_url: $imageUrl, updated_at: $updatedAt), username: $username';
  }
}
