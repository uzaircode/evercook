import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evercook/core/common/entities/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final AuthRemoteDataSource authRemoteDataSource;

  AppUserCubit({required this.authRemoteDataSource}) : super(AppUserInitial());

  Future<void> fetchCurrentUser() async {
    try {
      final session = authRemoteDataSource.currentUserSession;
      if (session != null) {
        final userData = await authRemoteDataSource.getCurrentUserData();
        if (userData != null) {
          emit(AppUserLoggedIn(userData));
        } else {
          emit(AppUserSignedOut());
        }
      } else {
        emit(AppUserSignedOut());
      }
    } catch (e) {
      print('executed');
    }
  }

  void updateUser(User? user) {
    if (user == null) {
      LoggerService.logger.i('Emitting AppUserInitial');
      emit(AppUserInitial());
    } else {
      LoggerService.logger.i('Emitting AppUserLoggedIn with user: $user');
      emit(AppUserLoggedIn(user));
    }
  }

  void updateUserData(User updatedUser) {
    if (state is AppUserLoggedIn) {
      emit(AppUserLoggedIn(updatedUser));
    }
  }
}
