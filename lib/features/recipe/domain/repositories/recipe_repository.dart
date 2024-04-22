import 'dart:io';

import 'package:evercook/core/error/failures.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class RecipeRepository {
  Future<Either<Failure, Recipe>> uploadRecipe({
    required String title,
    required String userId,
    required String description,
    required String prepTime,
    required String cookTime,
    required int servings,
    required File image,
  });

  Future<Either<Failure, List<Recipe>>> getAllRecipes();
}
