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
      notes: params.notes,
      sources: params.sources,
    );
  }
}

class UploadRecipeParams {
  final String userId;
  final String? title;
  final String? description;
  final String? prepTime;
  final String? cookTime;
  final int? servings;
  final String? notes;
  final String? sources;
  final File? imageUrl;

  UploadRecipeParams({
    required this.userId,
    this.title,
    this.description,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.notes,
    this.sources,
    this.imageUrl,
  });
}
