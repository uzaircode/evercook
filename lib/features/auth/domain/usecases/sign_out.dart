import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  SignOut(this.authRepository);

  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await authRepository.signOut();
  }
}
