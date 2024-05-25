import 'dart:io';

import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadRecipeUseCase implements UseCase<Recipe, UploadRecipeParams> {
  final RecipeRepository recipeRepository;

  UploadRecipeUseCase(this.recipeRepository);

  @override
  Future<Either<Failure, Recipe>> call(params) async {
    return await recipeRepository.uploadRecipe(
      userId: params.userId,
      name: params.name,
      description: params.description,
      prepTime: params.prepTime,
      cookTime: params.cookTime,
      servings: params.servings,
      image: params.imageUrl,
      ingredients: params.ingredients,
      directions: params.directions,
      notes: params.notes,
      sources: params.sources,
    );
  }
}

class UploadRecipeParams {
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
  final File? imageUrl;

  UploadRecipeParams({
    required this.userId,
    this.name,
    this.description,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.ingredients,
    this.directions,
    this.notes,
    this.sources,
    this.imageUrl,
  });
}
