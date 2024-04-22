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
      'userId': userId,
      'description': description,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'imageUrl': imageUrl,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RecipeModel.fromJson(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      prepTime: map['prepTime'] as String,
      cookTime: map['cookTime'] as String,
      servings: map['servings'] as int,
      imageUrl: map['imageUrl'] as String,
      updatedAt: map['updatedAt'] == null
          ? DateTime.now()
          : DateTime.parse(
              map['updatedAt'],
            ),
    );
  }

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, userId: $userId, description: $description, prepTime: $prepTime, cookTime: $cookTime, servings: $servings, imageUrl: $imageUrl, updatedAt: $updatedAt)';
  }
}
