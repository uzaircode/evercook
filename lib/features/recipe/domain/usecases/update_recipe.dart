import 'dart:io';

import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateRecipe implements UseCase<Recipe, UpdateRecipeParams> {
  final RecipeRepository recipeRepository;

  UpdateRecipe(this.recipeRepository);

  @override
  Future<Either<Failure, Recipe>> call(params) async {
    return await recipeRepository.updateRecipe(
      title: params.title,
      userId: params.userId,
      description: params.description,
      prepTime: params.prepTime,
      cookTime: params.cookTime,
      servings: params.servings,
      image: params.imageUrl,
    );
  }
}

class UpdateRecipeParams {
  final String userId;
  final String title;
  final String description;
  final String prepTime;
  final String cookTime;
  final int servings;
  final File imageUrl;

  UpdateRecipeParams({
    required this.userId,
    required this.title,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.imageUrl,
  });
}
