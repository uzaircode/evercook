import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/error/error_handler.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/cookbook/data/models/cookbook_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class CookbookRemoteDataSource {
  Future<void> uploadCookbook({
    required CookbookModel cookbook,
    required List<String> selectedRecipes,
  });
}

class CookbookRemoteDataSourceImpl implements CookbookRemoteDataSource {
  final SupabaseClient supabaseClient;

  CookbookRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> uploadCookbook({
    required CookbookModel cookbook,
    required List<String> selectedRecipes,
  }) async {
    try {
      LoggerService.logger.i('Uploading cookbook: ${cookbook.toJson()}');

      final cookbookResponse = await supabaseClient.from(DBConstants.cookbook).insert({
        'title': cookbook.title,
        'public': cookbook.public,
      }).select('*');

      final cookbookId = cookbookResponse[0]['id'] as String;

      for (String recipeId in selectedRecipes) {
        await Supabase.instance.client.from(DBConstants.cookbook_recipes).insert({
          'cookbook_id': cookbookId,
          'recipe_id': recipeId,
          'user_id': Supabase.instance.client.auth.currentSession!.user.id,
        });
      }
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }
}
