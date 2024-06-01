import 'dart:io';
import 'package:evercook/core/error/failures.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class RecipeRepository {
  Future<Either<Failure, Recipe>> uploadRecipe({
    String? name,
    required String userId,
    String? description,
    String? prepTime,
    String? cookTime,
    String? servings,
    List<String>? ingredients,
    File? image,
    String? directions,
    String? notes,
    String? sources,
    String? utensils,
    bool? public,
  });

  Future<Either<Failure, List<Recipe>>> getAllRecipes();

  Future<Either<Failure, Recipe>> deleteRecipe({
    required String id,
  });
}
