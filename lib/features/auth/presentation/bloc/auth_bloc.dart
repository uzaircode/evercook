import 'package:evercook/core/common/entities/user.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:evercook/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:evercook/features/auth/domain/usecases/user_login_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evercook/features/auth/domain/usecases/user_sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUpUseCase _userSignUp;
  final UserLoginUseCase _userLogin;
  final CurrentUserUseCase _currentUser;
  final AppUserCubit _appUserCubit;
  final SignOutUseCase _signOut;

  AuthBloc({
    required UserSignUpUseCase userSignUp,
    required UserLoginUseCase userLogin,
    required CurrentUserUseCase currentUser,
    required AppUserCubit appUserCubit,
    required SignOutUseCase signOut,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _signOut = signOut,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isCurrentUserLoggedIn);
    on<AuthSignOut>(_signOutUser);
  }

  void _signOutUser(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signOut(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSignedOut()),
    );
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        name: event.name,
        password: event.password,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogin(
      UserSignInParams(email: event.email, password: event.password),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _isCurrentUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}




//call usecase in the bloc

/* AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
  }
*/
