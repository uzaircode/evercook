import 'package:evercook/core/common/entities/user.dart';
import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class SignInWithGoogleUseCase implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  SignInWithGoogleUseCase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.signInWithGoogle();
  }
}
