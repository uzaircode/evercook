import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUserUseCase implements UseCase<void, UpdateUserParams> {
  final AuthRepository authRepository;

  UpdateUserUseCase(this.authRepository);

  @override
  Future<Either<Failure, void>> call(UpdateUserParams params) async {
    return await authRepository.updateUser(
      name: params.name,
      bio: params.bio,
    );
  }
}

class UpdateUserParams {
  final String name;
  final String bio;

  UpdateUserParams({
    required this.name,
    required this.bio,
  });
}
