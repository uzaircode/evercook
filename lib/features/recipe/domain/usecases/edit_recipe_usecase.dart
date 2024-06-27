import 'dart:io';

import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:fpdart/fpdart.dart';

class EditRecipeUseCase implements UseCase<Recipe, EditRecipeParams> {
  final RecipeRepository recipeRepository;

  EditRecipeUseCase(this.recipeRepository);

  @override
  Future<Either<Failure, Recipe>> call(EditRecipeParams params) async {
    return await recipeRepository.editRecipe(
      id: params.id,
      userId: params.userId,
      name: params.name,
      description: params.description,
      prepTime: params.prepTime,
      cookTime: params.cookTime,
      image: params.image,
      servings: params.servings,
      directions: params.directions,
      ingredients: params.ingredients,
      notes: params.notes,
      sources: params.sources,
      utensils: params.utensils,
      public: params.public,
    );
  }
}

class EditRecipeParams {
  final String id;
  final String userId;
  final String? name;
  final String? description;
  final String? prepTime;
  final String? cookTime;
  final String? servings;
  final String? directions;
  final List<String>? ingredients;
  final String? notes;
  final String? sources;
  final String? utensils;
  final bool? public;
  final File? image;

  EditRecipeParams({
    required this.id,
    required this.userId,
    this.name,
    this.description,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.image,
    this.ingredients,
    this.directions,
    this.notes,
    this.sources,
    this.utensils,
    this.public,
  });
}
