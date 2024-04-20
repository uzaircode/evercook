import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evercook/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;

  AuthBloc({
    required UserSignUp userSignUp,
  })  : _userSignUp = userSignUp,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(
      (event, emit) async {
        final res = await _userSignUp(
          UserSignUpParams(
            email: event.email,
            name: event.name,
            password: event.password,
          ),
        );
        res.fold(
          (l) => emit(AuthFailure(l.message)),
          (r) => emit(AuthSuccess(r)),
        );
      },
    );
  }

  void _onAuthSignUp() {}
}




//call usecase in the bloc








/* AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
  }
*/
