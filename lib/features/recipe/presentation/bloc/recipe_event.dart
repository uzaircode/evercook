part of 'recipe_bloc.dart';

@immutable
sealed class RecipeEvent {}

final class RecipeUpload extends RecipeEvent {
  final String? title;
  final String userId;
  final String? description;
  final String? prepTime;
  final String? cookTime;
  final int? servings;
  final File? image;
  final String? sources;
  final String? notes;

  RecipeUpload({
    this.title,
    required this.userId,
    this.description,
    this.prepTime,
    this.cookTime,
    this.servings,
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
