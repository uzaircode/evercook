import 'dart:io';

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
  Future<RecipeModel> updateRecipe({
    required RecipeModel recipe,
  });
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final SupabaseClient supabaseClient;

  RecipeRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<RecipeModel> uploadRecipe(RecipeModel recipe) async {
    try {
      LoggerService.logger.i('Uploading recipe: $recipe.toJson()');
      final recipeData = await supabaseClient.from('recipes').insert(recipe.toJson()).select();
      LoggerService.logger.i('Recipe uploaded: ${recipeData.first}');
      return RecipeModel.fromJson(recipeData.first);
    } on PostgrestException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.message);
    } catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadRecipeImage({
    required File image,
    required RecipeModel recipe,
  }) async {
    try {
      await supabaseClient.storage.from('recipe_images').upload(
            recipe.id,
            image,
          );

      return supabaseClient.storage.from('recipe_images').getPublicUrl(
            recipe.id,
          );
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final recipes = await supabaseClient.from('recipes').select(
            '*, profiles (name)',
          );

      return recipes
          .map((recipe) => RecipeModel.fromJson(recipe).copyWith(
                username: recipe['profiles']['name'],
              ))
          .toList();
    } on ServerException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.message);
    } on PostgrestException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.message);
    } catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RecipeModel> deleteRecipe(String id) async {
    try {
      LoggerService.logger.i('Deleting a recipe: $id');
      final recipe = await supabaseClient.from('recipes').delete().eq('id', id).select();

      return RecipeModel.fromJson(recipe.first);
    } on ServerException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.message);
    } on PostgrestException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.message);
    } catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RecipeModel> updateRecipe({
    required RecipeModel recipe,
  }) async {
    try {
      LoggerService.logger.i('Updating a recipe: $recipe');
      final recipeData =
          await supabaseClient.from('recipes').update(recipe.toJson()).eq('id', recipe.id).select().single();

      if (recipeData.containsKey('error')) {
        final errorMessage = recipeData['error'].toString();
        LoggerService.logger.e('Error updating recipe: $errorMessage');
        throw ServerException(errorMessage);
      }
      LoggerService.logger.i('Starting to update recipe: $recipe');

      return RecipeModel.fromJson(recipeData);
    } on ServerException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.message);
    } on PostgrestException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.message);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } on Exception catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.toString());
    } catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.toString());
    }
  }
}
