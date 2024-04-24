class IngredientWiki {
  final String id;
  final DateTime updatedAt;
  final String title;
  final String imageUrl;
  final String description;
  final String storage;
  final String foodScience;
  final String cookingTips;
  final String healthBenefits;

  IngredientWiki({
    required this.id,
    required this.updatedAt,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.storage,
    required this.foodScience,
    required this.cookingTips,
    required this.healthBenefits,
  });
}
