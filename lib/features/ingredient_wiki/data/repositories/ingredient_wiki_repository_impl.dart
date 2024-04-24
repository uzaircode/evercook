import 'package:evercook/core/error/exceptions.dart';
import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/ingredient_wiki/data/datasources/ingredient_wiki_remote_data_source.dart';
import 'package:evercook/features/ingredient_wiki/domain/entities/ingredient_wiki.dart';
import 'package:evercook/features/ingredient_wiki/domain/repositories/ingredient_wiki_repository.dart';
import 'package:fpdart/fpdart.dart';

class IngredientWikiRepositoryImpl implements IngredientWikiRepository {
  final IngredientWikiRemoteDataSource ingredientWikiRemoteDataSource;

  IngredientWikiRepositoryImpl(this.ingredientWikiRemoteDataSource);

  @override
  Future<Either<Failure, List<IngredientWiki>>> getAllIngredients() async {
    try {
      LoggerService.logger.i('executing...');

      final ingredientWiki = await ingredientWikiRemoteDataSource.getAllIngredients();

      return right(ingredientWiki);
    } on ServerException catch (e) {
      LoggerService.logger.i('ERRORRRR ON IMPL...');
      return left(Failure(e.message));
    }
  }
}
