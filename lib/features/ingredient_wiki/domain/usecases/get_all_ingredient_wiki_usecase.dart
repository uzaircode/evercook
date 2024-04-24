import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/ingredient_wiki/domain/entities/ingredient_wiki.dart';
import 'package:evercook/features/ingredient_wiki/domain/repositories/ingredient_wiki_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllIngredientWikiUseCase implements UseCase<List<IngredientWiki>, NoParams> {
  final IngredientWikiRepository ingredientWikiRepository;
  GetAllIngredientWikiUseCase(this.ingredientWikiRepository);

  @override
  Future<Either<Failure, List<IngredientWiki>>> call(NoParams params) async {
    return await ingredientWikiRepository.getAllIngredients();
  }
}
