part of 'ingredient_wiki_bloc.dart';

@immutable
sealed class IngredientWikiState {}

final class IngredientWikiInitial extends IngredientWikiState {}

final class IngredientWikiLoading extends IngredientWikiState {}

final class IngredientWikiFailure extends IngredientWikiState {
  final String error;

  IngredientWikiFailure(this.error);
}

final class IngredientWikiDisplaySuccess extends IngredientWikiState {
  final List<IngredientWiki> ingredients;

  IngredientWikiDisplaySuccess(this.ingredients);
}
