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
}
