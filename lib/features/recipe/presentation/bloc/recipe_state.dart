part of 'recipe_bloc.dart';

@immutable
sealed class RecipeState {}

final class RecipeInitial extends RecipeState {}

final class RecipeLoading extends RecipeState {}

final class RecipeFailure extends RecipeState {
  final String error;
  RecipeFailure(this.error);
}

final class RecipeUploadSuccess extends RecipeState {}
