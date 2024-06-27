import 'package:evercook/features/recipe/data/models/recipe_model.dart';

class MealPlan {
  final String id;
  final DateTime date;
  final List<RecipeModel> recipe;

  MealPlan({
    required this.id,
    required this.date,
    required this.recipe,
  });

  factory MealPlan.fromJson(Map<String, dynamic> map) {
    return MealPlan(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      recipe: (map['recipes'] as List).map((r) => RecipeModel.fromJson(r)).toList(),
    );
  }

  @override
  String toString() {
    return 'MealPlan(id: $id, date: $date, recipe: $recipe)';
  }
}
