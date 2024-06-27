import 'package:evercook/core/utils/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evercook/core/common/entities/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

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
