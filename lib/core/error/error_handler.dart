import 'package:evercook/core/error/exceptions.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorHandler {
  static Exception handleError(dynamic e) {
    LoggerService.logger.e('$e');
    if (e is PostgrestException) {
      throw ServerException('Postgres Exception: ${e.message}');
    } else if (e is StorageException) {
      throw ServerException('Storage Exception: ${e.message}');
    } else if (e is ServerException) {
      throw e;
    } else {
      return ServerException('Unexpected error: ${e.toString()}');
    }
  }
}
