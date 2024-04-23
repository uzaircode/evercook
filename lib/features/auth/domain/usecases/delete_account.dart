import 'package:evercook/core/error/failures.dart';
import 'package:evercook/core/usecase/usecase.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAccount implements UseCase<void, UserParams> {
  final AuthRepository authRepository;

  DeleteAccount(this.authRepository);
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    LoggerService.logger.i('DeleteAccount usecase called');
    LoggerService.logger.i('usecase - ${params.userId}');
    return await authRepository.deleteAccount(userId: params.userId);
  }
}

class UserParams {
  final String userId;

  UserParams({required this.userId});
}
