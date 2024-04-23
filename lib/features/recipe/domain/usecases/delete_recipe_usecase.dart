import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteRecipeUseCase implements UseCase<Recipe, DeleteRecipeParams> {
  final RecipeRepository recipeRepository;

  DeleteRecipeUseCase(this.recipeRepository);
  @override
  Future<Either<Failure, Recipe>> call(params) async {
    return await recipeRepository.deleteRecipe(id: params.id);
  }
}

class DeleteRecipeParams {
  final String id;

  DeleteRecipeParams({
    required this.id,
  });
}
