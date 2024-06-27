import 'dart:io';

import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/constant/bucket_constants.dart';
import 'package:evercook/core/error/error_handler.dart';
import 'package:evercook/core/error/exceptions.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/recipe/data/models/recipe_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RecipeRemoteDataSource {
  Session? get currentUserSession;

  Future<RecipeModel> uploadRecipe(RecipeModel recipe);
  Future<String> uploadRecipeImage({
    required File image,
    required RecipeModel recipe,
  });
  Future<String> uploadUpdatedRecipeImage({
    required File image,
    required RecipeModel recipe,
  });

  Future<List<RecipeModel>> getAllRecipes();
  Future<RecipeModel> deleteRecipe(String id);
  Future<RecipeModel> editRecipe(
    String userId,
    RecipeModel recipe,
  );
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final SupabaseClient supabaseClient;

  RecipeRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<RecipeModel> uploadRecipe(RecipeModel recipe) async {
    try {
      LoggerService.logger.i('Uploading recipe: ${recipe.toJson()}');
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
      await supabaseClient.storage.from(BucketConstants.recipeImagesBucket).upload(
            recipe.id,
            image,
          );

      return supabaseClient.storage.from(BucketConstants.recipeImagesBucket).getPublicUrl(
            recipe.id,
          );
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  @override
  Future<String> uploadUpdatedRecipeImage({
    required File image,
    required RecipeModel recipe,
  }) async {
    try {
      final imageName = '${recipe.id}_${DateTime.now().millisecondsSinceEpoch}';

      // Check if the image already exists and delete it
      final existingImageResponse =
          await supabaseClient.storage.from(BucketConstants.recipeImagesBucket).list(path: recipe.id);

      if (existingImageResponse.isNotEmpty) {
        for (var file in existingImageResponse) {
          await supabaseClient.storage.from(BucketConstants.recipeImagesBucket).remove([file.name]);
        }
      }

      // Upload the new image
      await supabaseClient.storage.from(BucketConstants.recipeImagesBucket).upload(
            imageName,
            image,
          );

      // Get the public URL of the uploaded image
      final imageUrl = supabaseClient.storage.from(BucketConstants.recipeImagesBucket).getPublicUrl(
            imageName,
          );

      return imageUrl;
    } catch (e) {
      LoggerService.logger.e('Error uploading image: $e');
      throw ErrorHandler.handleError(e);
    }
  }

  @override
  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final recipes = await supabaseClient
          .from(DBConstants.recipesTable)
          .select(
            '*, profiles (name)',
          )
          .eq(
            'user_id',
            currentUserSession!.user.id,
          );

      return recipes
          .map(
            (recipe) => RecipeModel.fromJson(recipe).copyWith(
              userName: recipe['profiles']['name'],
            ),
          )
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

  @override
  Future<RecipeModel> editRecipe(
    String userId,
    RecipeModel recipe,
  ) async {
    try {
      LoggerService.logger.i('Updating recipe with ID: ${recipe.id}');
      LoggerService.logger.i('Recipe data: ${recipe.toJson()}');

      final response = await supabaseClient
          .from(DBConstants.recipesTable)
          .update({
            'name': recipe.name,
            'description': recipe.description,
            'prep_time': recipe.prepTime,
            'cook_time': recipe.cookTime,
            'servings': recipe.servings,
            'directions': recipe.directions,
            'ingredients': recipe.ingredients,
            'image_url': recipe.imageUrl,
            'notes': recipe.notes,
            'sources': recipe.sources,
            'utensils': recipe.utensils,
            'public': recipe.public,
          })
          .eq('id', recipe.id)
          .select()
          .single();

      LoggerService.logger.i('Update successful: $response');
      return RecipeModel.fromJson(response);
    } catch (e) {
      LoggerService.logger.e('Exception during update: $e');
      throw ErrorHandler.handleError(e);
    }
  }
}
