import 'dart:io';

import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/domain/usecases/delete_recipe_usecase.dart';
import 'package:evercook/features/recipe/domain/usecases/get_all_recipes_usecase.dart';
import 'package:evercook/features/recipe/domain/usecases/upload_recipe_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final UploadRecipeUseCase _uploadRecipe;
  final GetAllRecipesUseCase _getAllRecipes;
  final DeleteRecipeUseCase _deleteRecipe;

  RecipeBloc({
    required UploadRecipeUseCase uploadRecipe,
    required GetAllRecipesUseCase getAllRecipes,
    required DeleteRecipeUseCase deleteRecipe,
  })  : _uploadRecipe = uploadRecipe,
        _getAllRecipes = getAllRecipes,
        _deleteRecipe = deleteRecipe,
        super(RecipeInitial()) {
    on<RecipeEvent>((event, emit) => emit(RecipeLoading()));
    on<RecipeUpload>(_onRecipeUpload);
    on<RecipeFetchAllRecipes>(_onFetchAllRecipes);
    on<RecipeDelete>(_onDeleteRecipe);
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

  void _onDeleteRecipe(
    RecipeDelete event,
    Emitter<RecipeState> emit,
  ) async {
    final res = await _deleteRecipe(DeleteRecipeParams(id: event.id));

    res.fold(
      (l) => emit(RecipeFailure(l.message)),
      (r) => emit(RecipeDeleteSuccess()),
    );
  }
}
