import 'package:evercook/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class CookbookRepository {
  Future<Either<Failure, void>> uploadCookbook();
}
