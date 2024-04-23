import 'package:evercook/core/error/exceptions.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<void> signOut();

  Future<void> deleteAccount({
    required String userId,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
      );

      if (response.user == null) {
        throw const ServerException('User is null');
      }

      LoggerService.logger.i(response.user!.toJson());
      return UserModel.fromJson(response.user!.toJson()); //i dont understand here, why fromJson -> toJson?
    } on AuthException catch (e) {
      LoggerService.logger.e('Uknown error: $e');
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const ServerException('User is null');
      }

      LoggerService.logger.i(response.user!.toJson());
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      LoggerService.logger.i('Signing out...');
      final response = await supabaseClient.auth.signOut();

      return response;
    } on AuthException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteAccount({required String userId}) async {
    try {
      LoggerService.logger.i('Deleting user account $userId...');
      final response = await supabaseClient.functions.invoke('user-self-deletion');

      return response;
    } on AuthException catch (e) {
      LoggerService.logger.e('Error deleting account: $e');
      throw ServerException('Error deleting account: $e');
    } on ServerException catch (e) {
      LoggerService.logger.e('Error deleting account: $e');
      throw ServerException('Error deleting account: $e');
    } catch (e) {
      LoggerService.logger.e('Error deleting account: $e');
      throw ServerException('Error deleting account: $e');
    }
  }
}
