import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cookbook_event.dart';
part 'cookbook_state.dart';

class CookbookBloc extends Bloc<CookbookEvent, CookbookState> {
  CookbookBloc() : super(CookbookInitial()) {
    on<CookbookEvent>((event, emit) {});
  }
}
