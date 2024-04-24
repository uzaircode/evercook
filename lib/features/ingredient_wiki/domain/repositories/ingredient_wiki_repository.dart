import 'package:evercook/core/error/failures.dart';
import 'package:evercook/features/ingredient_wiki/domain/entities/ingredient_wiki.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class IngredientWikiRepository {
  Future<Either<Failure, List<IngredientWiki>>> getAllIngredients();
}
