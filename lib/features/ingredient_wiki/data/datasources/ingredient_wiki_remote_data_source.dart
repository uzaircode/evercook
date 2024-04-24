import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/error/exceptions.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/ingredient_wiki/data/models/ingredient_wiki_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class IngredientWikiRemoteDataSource {
  Future<List<IngredientWikiModel>> getAllIngredients();
}

class IngredientWikiRemoteDataSourceImpl implements IngredientWikiRemoteDataSource {
  final SupabaseClient supabaseClient;

  IngredientWikiRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<IngredientWikiModel>> getAllIngredients() async {
    try {
      LoggerService.logger.i('executing remote data source...');
      final ingredients = await supabaseClient.from(DBConstants.ingredientsWikiTable).select('*');

      LoggerService.logger.i('ingredients: $ingredients');
      return ingredients
          .map(
            (blog) => IngredientWikiModel.fromJson(blog),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
