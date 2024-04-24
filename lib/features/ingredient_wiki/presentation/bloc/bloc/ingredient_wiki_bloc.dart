import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ingredient_wiki_event.dart';
part 'ingredient_wiki_state.dart';

class IngredientWikiBloc extends Bloc<IngredientWikiEvent, IngredientWikiState> {
  IngredientWikiBloc() : super(IngredientWikiInitial()) {
    on<IngredientWikiEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
