part of 'recipe_bloc.dart';

@immutable
sealed class RecipeEvent {}

final class RecipeUpload extends RecipeEvent {
  final String? name;
  final String userId;
  final String? description;
  final String? prepTime;
  final String? cookTime;
  final String? servings;
  final List<String>? ingredients;
  final String? directions;
  final File? image;
  final String? sources;
  final String? notes;

  RecipeUpload({
    this.name,
    required this.userId,
    this.description,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.directions,
    this.ingredients,
    this.image,
    this.sources,
    this.notes,
  });
}

final class RecipeFetchAllRecipes extends RecipeEvent {}

final class RecipeDelete extends RecipeEvent {
  final String id;

  RecipeDelete({
    required this.id,
  });
}
