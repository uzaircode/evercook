import 'dart:io';

import 'package:evercook/core/common/entities/user.dart';
import 'package:evercook/core/error/exceptions.dart';
import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:evercook/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  const AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await authRemoteDataSource.getCurrentUserData();

      if (user == null) {
        return left(Failure('User is not logged in.'));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      await authRemoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );

      return _getUser(
        () async => await authRemoteDataSource.signInWithEmailPassword(
          email: email,
          password: password,
        ),
      );
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      await authRemoteDataSource
          .signInWithGoogle(); // Assuming this method is just for the sign-in process and does not return user data.
      final user = await authRemoteDataSource.getCurrentUserData(); // This should fetch and return a User object.

      if (user != null) {
        return Right(user);
      } else {
        throw ServerException('User data is null');
      }
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final response = await authRemoteDataSource.signOut();

      final user = await authRemoteDataSource.getCurrentUserData();
      LoggerService.logger.i('User: $user');
      return right(response);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, void>> recoverPassword({
    required String email,
  }) async {
    try {
      final response = await authRemoteDataSource.recoverPassword(email: email);

      LoggerService.logger.i('Executing for auth repository implementation....');

      return right(response);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  Future<Either<Failure, User>> updateUser({
    required String name,
    required String bio,
    File? image,
  }) async {
    try {
      LoggerService.logger.i('Updating user...');

      // First, update the user's name and bio
      var user = await authRemoteDataSource.updateUser(
        name: name,
        bio: bio,
      );

      // Upload the new profile picture and get the URL
      String? imageUrl;
      if (image != null) {
        imageUrl = await authRemoteDataSource.uploadProfileUserImage(image: image);
        LoggerService.logger.i('Image URL: $imageUrl');
      }

      // Update the user with the new avatar URL
      if (imageUrl != null) {
        user = await authRemoteDataSource.updateUser(
          name: name,
          bio: bio,
          avatarUrl: imageUrl,
        );
      }

      LoggerService.logger.i('User updated with new image: $user');
      return right(user);
    } on ServerException catch (e) {
      LoggerService.logger.e('Error updating user: ${e.toString()}');
      return left(Failure("Server error occurred"));
    } catch (e) {
      LoggerService.logger.e('Unexpected error updating user: ${e.toString()}');
      return left(Failure("Unexpected error occurred"));
    }
  }
}
