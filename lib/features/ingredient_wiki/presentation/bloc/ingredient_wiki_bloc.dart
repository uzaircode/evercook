import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/ingredient_wiki/domain/entities/ingredient_wiki.dart';
import 'package:evercook/features/ingredient_wiki/domain/usecases/get_all_ingredient_wiki_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ingredient_wiki_event.dart';
part 'ingredient_wiki_state.dart';

class IngredientWikiBloc extends Bloc<IngredientWikiEvent, IngredientWikiState> {
  final GetAllIngredientWikiUseCase _getAllIngredientsWiki;

  IngredientWikiBloc({
    required GetAllIngredientWikiUseCase getAllIngredientsWiki,
  })  : _getAllIngredientsWiki = getAllIngredientsWiki,
        super(IngredientWikiInitial()) {
    on<IngredientWikiEvent>((event, emit) => emit(IngredientWikiLoading()));
    on<IngredientWikiFetchAllIngredients>(_onFetchAllIngredientsWiki);
  }

  void _onFetchAllIngredientsWiki(
    IngredientWikiFetchAllIngredients event,
    Emitter<IngredientWikiState> emit,
  ) async {
    LoggerService.logger.i('Fetching all ingredients wiki...');
    final res = await _getAllIngredientsWiki(NoParams());
    LoggerService.logger.i('Ingredients wiki fetched: $res');

    res.fold(
      (l) => emit(IngredientWikiFailure(l.message)),
      (r) => emit(IngredientWikiDisplaySuccess(r)),
    );
  }
}
