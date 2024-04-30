import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class RecoverPasswordUsecase implements UseCase<void, UserRecoverPasswordParams> {
  final AuthRepository authRepository;
  RecoverPasswordUsecase(this.authRepository);

  @override
  Future<Either<Failure, void>> call(UserRecoverPasswordParams params) async {
    return await authRepository.recoverPassword(email: params.email);
  }
}

class UserRecoverPasswordParams {
  final String email;

  UserRecoverPasswordParams({
    required this.email,
  });
}
