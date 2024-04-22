part of 'recipe_bloc.dart';

@immutable
sealed class RecipeEvent {}

final class RecipeUpload extends RecipeEvent {
  final String title;
  final String userId;
  final String description;
  final String prepTime;
  final String cookTime;
  final int servings;
  final File image;

  RecipeUpload({
    required this.title,
    required this.userId,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.image,
  });
}

final class RecipeFetchAllRecipes extends RecipeEvent {}

final class RecipeDelete extends RecipeEvent {
  final String id;

  RecipeDelete({
    required this.id,
  });
}

final class RecipeUpdate extends RecipeEvent {
  final String title;
  final String userId;
  final String description;
  final String prepTime;
  final String cookTime;
  final int servings;
  final File image;

  RecipeUpdate({
    required this.title,
    required this.userId,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.image,
  });
}
