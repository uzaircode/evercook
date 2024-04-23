import 'dart:io';

import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/constant/storage_constants.dart';
import 'package:evercook/core/error/error_handler.dart';
import 'package:evercook/core/error/exceptions.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/recipe/data/models/recipe_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RecipeRemoteDataSource {
  Future<RecipeModel> uploadRecipe(RecipeModel recipe);
  Future<String> uploadRecipeImage({
    required File image,
    required RecipeModel recipe,
  });
  Future<List<RecipeModel>> getAllRecipes();
  Future<RecipeModel> deleteRecipe(String id);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final SupabaseClient supabaseClient;

  RecipeRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<RecipeModel> uploadRecipe(RecipeModel recipe) async {
    try {
      LoggerService.logger.i('Uploading recipe: $recipe.toJson()');
      final recipeData = await supabaseClient.from(DBConstants.recipesTable).insert(recipe.toJson()).select();
      LoggerService.logger.i('Recipe uploaded: ${recipeData.first}');
      return RecipeModel.fromJson(recipeData.first);
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  @override
  Future<String> uploadRecipeImage({
    required File image,
    required RecipeModel recipe,
  }) async {
    try {
      await supabaseClient.storage.from(StorageConstants.recipeImagesBucket).upload(
            recipe.id,
            image,
          );

      return supabaseClient.storage.from(StorageConstants.recipeImagesBucket).getPublicUrl(
            recipe.id,
          );
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  @override
  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final recipes = await supabaseClient.from(DBConstants.recipesTable).select(
            '*, profiles (name)',
          );

      return recipes
          .map((recipe) => RecipeModel.fromJson(recipe).copyWith(
                username: recipe['profiles']['name'],
              ))
          .toList();
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  @override
  Future<RecipeModel> deleteRecipe(String id) async {
    try {
      LoggerService.logger.i('Deleting a recipe: $id');
      final recipe = await supabaseClient.from(DBConstants.recipesTable).delete().eq('id', id).select();

      if (recipe.isEmpty) {
        throw const ServerException('Recipe not found');
      }

      return RecipeModel.fromJson(recipe.first);
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }
}
