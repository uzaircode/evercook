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
    String? name,
    String? description,
    String? prepTime,
    String? cookTime,
    String? servings,
    List<String>? ingredients,
    String? directions,
    String? notes,
    String? sources,
    String? utensils,
    bool? public,
    File? image,
  }) async {
    try {
      RecipeModel recipeModel = RecipeModel(
        id: const Uuid().v1(),
        name: name,
        userId: userId,
        description: description,
        prepTime: prepTime,
        cookTime: cookTime,
        servings: servings,
        ingredients: ingredients ?? [],
        directions: directions,
        notes: notes,
        sources: sources,
        imageUrl: '',
        utensils: utensils,
        public: public,
        updatedAt: DateTime.now(),
      );

      // final imageUrl = await recipeRemoteDataSource.uploadRecipeImage(
      //   image: image!,
      //   recipe: recipeModel,
      // );

      if (image != null) {
        final imageUrl = await recipeRemoteDataSource.uploadRecipeImage(
          image: image,
          recipe: recipeModel,
        );
        recipeModel = recipeModel.copyWith(imageUrl: imageUrl);
      }

      final uploadedRecipe = await recipeRemoteDataSource.uploadRecipe(recipeModel);

      return right(uploadedRecipe);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getAllRecipes() async {
    try {
      final recipes = await recipeRemoteDataSource.getAllRecipes();
      return right(recipes);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, Recipe>> deleteRecipe({
    required String id,
  }) async {
    try {
      final deletedRecipe = await recipeRemoteDataSource.deleteRecipe(id);

      return right(deletedRecipe);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}
