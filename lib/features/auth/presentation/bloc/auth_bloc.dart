import 'dart:io';

import 'package:evercook/core/common/entities/user.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:evercook/features/auth/domain/usecases/recover_password_usecase.dart';
import 'package:evercook/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:evercook/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:evercook/features/auth/domain/usecases/user_login_usecase.dart';
import 'package:evercook/features/auth/domain/usecases/user_signin_google_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evercook/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUpUseCase _userSignUp;
  final UserLoginUseCase _userLogin;
  final CurrentUserUseCase _currentUser;
  final AppUserCubit _appUserCubit;
  final SignOutUseCase _signOut;
  final RecoverPasswordUsecase _recoverPassword;
  final UpdateUserUseCase _updateUser;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final RecipeBloc _recipeBloc; // Add this

  AuthBloc({
    required UserSignUpUseCase userSignUp,
    required UserLoginUseCase userLogin,
    required CurrentUserUseCase currentUser,
    required AppUserCubit appUserCubit,
    required SignOutUseCase signOut,
    required RecoverPasswordUsecase recoverPassword,
    required UpdateUserUseCase updateUser,
    required SignInWithGoogleUseCase signInWithGoogle,
    required RecipeBloc recipeBloc, // Add this
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _signOut = signOut,
        _recoverPassword = recoverPassword,
        _updateUser = updateUser,
        _signInWithGoogle = signInWithGoogle,
        _recipeBloc = recipeBloc, // Initialize here
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isCurrentUserLoggedIn);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthRecoverPassword>(_onRecoverPassword);
    on<AuthUpdateUser>(_onUpdateUser);
    on<AuthUserSignInWithGoogle>(_onUserSignInWithGoogle);
  }

  Future<void> _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        name: event.name,
        password: event.password,
      ),
    );
    res.fold((l) => emit(AuthFailure(l.message)), (r) {
      LoggerService.logger.i('Current User Data login: ${r.toString()}');
      _emitAuthSuccess(r, emit);
      _isCurrentUserLoggedIn(AuthIsUserLoggedIn(), emit);
    });
  }

  Future<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserSignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        LoggerService.logger.i('Current User Data login: ${r.toString()}');
        _emitAuthSuccess(r, emit);
        _isCurrentUserLoggedIn(AuthIsUserLoggedIn(), emit);
      },
    );
  }

  Future<void> _onUserSignInWithGoogle(
    AuthUserSignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _signInWithGoogle(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        LoggerService.logger.i('Current User Data login: ${r.toString()}');
        _emitAuthSuccess(r, emit);
        _isCurrentUserLoggedIn(AuthIsUserLoggedIn(), emit);
      },
    );
  }

  Future<void> _isCurrentUserLoggedIn(AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        LoggerService.logger.d('current user logged in executed!');
        _emitAuthSuccess(r, emit);
      },
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    LoggerService.logger.i('_emitAuthSuccess raw user data: ${user.toString()}');
    _appUserCubit.updateUser(user);
    LoggerService.logger.i('_emitAuthSuccess is Executing : $user');
    emit(AuthSuccess(user));
  }

  Future<void> _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _signOut(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        _appUserCubit.updateUser(null);
        _recipeBloc.add(RecipeReset()); // Dispatch the reset event
        LoggerService.logger.i('Current User Data after logout: ${r.toString()}');
        emit(AuthInitial());
        LoggerService.logger.i('User signed out successfully.');
      },
    );
  }

  Future<void> _onRecoverPassword(AuthRecoverPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _recoverPassword(UserRecoverPasswordParams(email: event.email));
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthRecoverPasswordSuccess()),
    );
  }

  Future<void> _onUpdateUser(AuthUpdateUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _updateUser(UpdateUserParams(
      name: event.name,
      bio: event.bio,
      image: event.image,
    ));
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        LoggerService.logger.i('BLoC Success triggered');
        emit(AuthUpdateUserSuccess(r));
      },
    );
  }
}
