part of 'app_user.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoading extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;
  AppUserLoggedIn(this.user);
}

final class AppUserSignedOut extends AppUserState {}
