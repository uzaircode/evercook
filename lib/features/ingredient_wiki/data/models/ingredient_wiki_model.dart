import 'package:evercook/features/ingredient_wiki/domain/entities/ingredient_wiki.dart';

class IngredientWikiModel extends IngredientWiki {
  IngredientWikiModel({
    required super.id,
    required super.updatedAt,
    required super.title,
    required super.imageUrl,
    required super.description,
    required super.storage,
    required super.foodScience,
    required super.cookingTips,
    required super.healthBenefits,
  });

  factory IngredientWikiModel.fromJson(Map<String, dynamic> json) {
    return IngredientWikiModel(
      id: json['id'] ?? '',
      updatedAt: DateTime.parse(json['updated_at']),
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
      storage: json['storage'] ?? '',
      foodScience: json['food_science'] ?? '',
      cookingTips: json['cooking_tips'] ?? '',
      healthBenefits: json['health_benefits'] ?? '',
    );
  }
}
