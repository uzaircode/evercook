import 'dart:io';

import 'package:evercook/core/common/entities/user.dart';
import 'package:evercook/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> recoverPassword({
    required String email,
  });

  Future<Either<Failure, User>> updateUser({
    required String name,
    required String bio,
    required File image,
  });
}
