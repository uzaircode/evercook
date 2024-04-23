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
      title: params.title,
      description: params.description,
      prepTime: params.prepTime,
      cookTime: params.cookTime,
      servings: params.servings,
      image: params.imageUrl,
    );
  }
}

class UploadRecipeParams {
  final String userId;
  final String title;
  final String description;
  final String prepTime;
  final String cookTime;
  final int servings;
  final File imageUrl;

  UploadRecipeParams({
    required this.userId,
    required this.title,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.imageUrl,
  });
}
