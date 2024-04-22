import 'dart:io';

import 'package:evercook/core/error/exceptions.dart';
import 'package:evercook/core/error/failures.dart';
import 'package:evercook/features/recipe/data/datasources/recipe_remote_data_source.dart';
import 'package:evercook/features/recipe/data/models/recipe_model.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource recipeRemoteDataSource;

  RecipeRepositoryImpl(this.recipeRemoteDataSource);

  @override
  Future<Either<Failure, Recipe>> uploadRecipe({
    required String userId,
    required String title,
    required String description,
    required String prepTime,
    required String cookTime,
    required int servings,
    required File image,
  }) async {
    try {
      RecipeModel recipeModel = RecipeModel(
        id: const Uuid().v1(),
        title: title,
        userId: userId,
        description: description,
        prepTime: prepTime,
        cookTime: cookTime,
        servings: servings,
        imageUrl: '',
        updatedAt: DateTime.now(),
      );

      final imageUrl = await recipeRemoteDataSource.uploadRecipeImage(
        image: image,
        recipe: recipeModel,
      );

      recipeModel = recipeModel.copyWith(imageUrl: imageUrl);

      final uploadedRecipe = await recipeRemoteDataSource.uploadRecipe(recipeModel);

      return right(uploadedRecipe);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}
