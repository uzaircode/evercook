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
  final String? utensils;
  final bool? public;

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
    this.utensils,
    this.public,
  });
}

final class RecipeFetchAllRecipes extends RecipeEvent {}

class RecipeReset extends RecipeEvent {} // Add this event

final class RecipeDelete extends RecipeEvent {
  final String id;

  RecipeDelete({
    required this.id,
  });
}

final class RecipeEdit extends RecipeEvent {
  final String id;
  final String userId;
  final String? name;
  final String? description;
  final String? prepTime;
  final String? cookTime;
  final String? servings;
  final List<String>? ingredients;
  final String? directions;
  final File? image;
  final String? sources;
  final String? notes;
  final String? utensils;
  final bool? public;

  RecipeEdit({
    required this.id,
    required this.userId,
    this.name,
    this.description,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.directions,
    this.ingredients,
    this.image,
    this.sources,
    this.notes,
    this.utensils,
    this.public,
  });
}
