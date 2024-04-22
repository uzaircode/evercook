import 'dart:io';

import 'package:evercook/features/recipe/domain/usecases/upload_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final UploadRecipe _uploadRecipe;

  RecipeBloc({
    required UploadRecipe uploadRecipe,
  })  : _uploadRecipe = uploadRecipe,
        super(RecipeInitial()) {
    on<RecipeEvent>((event, emit) => emit(RecipeLoading()));
    on<RecipeUpload>(_onRecipeUpload);
  }

  void _onRecipeUpload(RecipeUpload event, Emitter<RecipeState> emit) async {
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
}
