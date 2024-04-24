part of 'ingredient_wiki_bloc.dart';

@immutable
sealed class IngredientWikiEvent {}

final class IngredientWikiFetchAllIngredients extends IngredientWikiEvent {}
