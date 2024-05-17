import 'dart:io';
import 'package:evercook/core/error/failures.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class RecipeRepository {
  Future<Either<Failure, Recipe>> uploadRecipe({
    String? title,
    required String userId,
    String? description,
    String? prepTime,
    String? cookTime,
    int? servings,
    File? image,
    String? directions,
    String? notes,
    String? sources,
  });

  Future<Either<Failure, List<Recipe>>> getAllRecipes();

  Future<Either<Failure, Recipe>> deleteRecipe({
    required String id,
  });
}
