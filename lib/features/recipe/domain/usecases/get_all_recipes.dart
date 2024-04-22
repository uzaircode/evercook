import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllRecipes implements UseCase<List<Recipe>, NoParams> {
  final RecipeRepository recipeRepository;
  GetAllRecipes(this.recipeRepository);

  @override
  Future<Either<Failure, List<Recipe>>> call(NoParams params) async {
    return await recipeRepository.getAllRecipes();
  }
}
