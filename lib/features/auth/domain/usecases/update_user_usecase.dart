import 'dart:io';

import 'package:evercook/core/common/entities/user.dart';
import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUserUseCase implements UseCase<User, UpdateUserParams> {
  final AuthRepository authRepository;

  UpdateUserUseCase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UpdateUserParams params) async {
    return await authRepository.updateUser(
      name: params.name,
      bio: params.bio,
      image: params.image,
    );
  }
}

class UpdateUserParams {
  final String name;
  final String bio;
  final File image;

  UpdateUserParams({
    required this.name,
    required this.bio,
    required this.image,
  });
}
