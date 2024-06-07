part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String name;
  final String password;

  AuthSignUp({required this.email, required this.name, required this.password});
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
}

final class AuthIsUserLoggedIn extends AuthEvent {}

final class AuthSignOut extends AuthEvent {}

final class AuthRecoverPassword extends AuthEvent {
  final String email;

  AuthRecoverPassword({required this.email});
}

final class AuthUpdateUser extends AuthEvent {
  final String name;
  final String bio;
  final File image;

  AuthUpdateUser({required this.name, required this.bio, required this.image});
}

final class AuthUserSignInWithGoogle extends AuthEvent {}
