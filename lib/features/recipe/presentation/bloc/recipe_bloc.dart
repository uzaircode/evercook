import 'dart:io';

import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/domain/usecases/get_all_recipes.dart';
import 'package:evercook/features/recipe/domain/usecases/upload_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final UploadRecipe _uploadRecipe;
  final GetAllRecipes _getAllRecipes;

  RecipeBloc({
    required UploadRecipe uploadRecipe,
    required GetAllRecipes getAllRecipes,
  })  : _uploadRecipe = uploadRecipe,
        _getAllRecipes = getAllRecipes,
        super(RecipeInitial()) {
    on<RecipeEvent>((event, emit) => emit(RecipeLoading()));
    on<RecipeUpload>(_onRecipeUpload);
    on<RecipeFetchAllRecipes>(_onFetchAllRecipes);
  }

  void _onRecipeUpload(
    RecipeUpload event,
    Emitter<RecipeState> emit,
  ) async {
    final res = await _uploadRecipe(UploadRecipeParams(
      userId: event.userId,
      title: event.title,
      description: event.description,
      prepTime: event.prepTime,
      cookTime: event.cookTime,
      servings: event.servings,
      imageUrl: event.image,
    ));

    res.fold(
      (l) => emit(RecipeFailure(l.message)),
      (r) => emit(RecipeUploadSuccess()),
    );
  }

  void _onFetchAllRecipes(
    RecipeFetchAllRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    final res = await _getAllRecipes(NoParams());

    res.fold(
      (l) => emit(RecipeFailure(l.message)),
      (r) => emit(RecipeDisplaySuccess(r)),
    );
  }
}
