import 'dart:io';

import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/domain/usecases/delete_recipe_usecase.dart';
import 'package:evercook/features/recipe/domain/usecases/edit_recipe_usecase.dart';
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
  final EditRecipeUseCase _editRecipe;

  RecipeBloc({
    required UploadRecipeUseCase uploadRecipe,
    required GetAllRecipesUseCase getAllRecipes,
    required DeleteRecipeUseCase deleteRecipe,
    required EditRecipeUseCase editRecipe,
  })  : _uploadRecipe = uploadRecipe,
        _getAllRecipes = getAllRecipes,
        _deleteRecipe = deleteRecipe,
        _editRecipe = editRecipe,
        super(RecipeInitial()) {
    on<RecipeUpload>(_onRecipeUpload);
    on<RecipeFetchAllRecipes>(_onFetchAllRecipes);
    on<RecipeDelete>(_onDeleteRecipe);
    on<RecipeReset>(_onResetRecipes); // Handle the reset event
    on<RecipeEdit>(_onEditRecipe);
  }

  Future<void> _onRecipeUpload(
    RecipeUpload event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    final res = await _uploadRecipe(UploadRecipeParams(
      userId: event.userId,
      name: event.name,
      description: event.description,
      prepTime: event.prepTime,
      cookTime: event.cookTime,
      servings: event.servings,
      ingredients: event.ingredients,
      directions: event.directions,
      imageUrl: event.image,
      notes: event.notes,
      sources: event.sources,
      utensils: event.utensils,
      public: event.public,
    ));

    res.fold(
      (l) => emit(RecipeFailure(l.message)),
      (r) {
        emit(RecipeUploadSuccess());
        add(RecipeFetchAllRecipes());
      },
    );
  }

  Future<void> _onFetchAllRecipes(
    RecipeFetchAllRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    final res = await _getAllRecipes(NoParams());

    res.fold(
      (l) => emit(RecipeFailure(l.message)),
      (r) => emit(RecipeDisplaySuccess(r)),
    );
  }

  Future<void> _onDeleteRecipe(
    RecipeDelete event,
    Emitter<RecipeState> emit,
  ) async {
    final res = await _deleteRecipe(DeleteRecipeParams(id: event.id));

    res.fold(
      (l) => emit(RecipeFailure(l.message)),
      (r) {
        emit(RecipeDeleteSuccess());
        add(RecipeFetchAllRecipes());
      },
    );
  }

  void _onResetRecipes(
    RecipeReset event,
    Emitter<RecipeState> emit,
  ) {
    emit(RecipeInitial()); // Reset the state to initial
  }

  Future<void> _onEditRecipe(
    RecipeEdit event,
    Emitter<RecipeState> emit,
  ) async {
    final res = await _editRecipe(
      EditRecipeParams(
        id: event.id,
        userId: event.userId,
        name: event.name,
        description: event.description,
        prepTime: event.prepTime,
        cookTime: event.cookTime,
        servings: event.servings,
        directions: event.directions,
        ingredients: event.ingredients,
        image: event.image,
        notes: event.notes,
        sources: event.sources,
        utensils: event.utensils,
        public: event.public,
      ),
    );
    res.fold(
      (l) => emit(
        RecipeFailure(l.message),
      ),
      (r) {
        emit(RecipeUploadSuccess());
        add(RecipeFetchAllRecipes());
      },
    );
  }
}
