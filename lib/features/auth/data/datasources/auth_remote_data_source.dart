import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/error/exceptions.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/data/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> signInWithGoogle();

  Future<UserModel?> getCurrentUserData();

  Future<void> signOut();

  Future<void> recoverPassword({
    required String email,
  });

  Future<UserModel> updateUser({
    required String name,
    required String bio,
    String? avatarUrl,
  });

  Future<String> uploadProfileUserImage({
    required File image,
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
        final userData = await supabaseClient.from(DBConstants.profilesTable).select().eq(
              'id',
              currentUserSession!.user.id,
            );
        LoggerService.logger.d(userData);

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
      // Sign up the user
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

      // Load the default avatar from assets
      final ByteData imageData = await rootBundle.load('assets/images/default_avatar.png');
      final Uint8List bytes = imageData.buffer.asUint8List();

      // Define the image path
      final userId = response.user!.id;
      final imagePath = 'avatars/$userId/default_avatar.png';

      // Upload the default avatar to storage
      await supabaseClient.storage.from('avatars').uploadBinary(imagePath, bytes);

      // Ensuring the file is available by introducing a simple delay
      await Future.delayed(const Duration(seconds: 1)); // Example delay, adjust based on actual needs

      // Get the public URL of the uploaded image
      final avatarUrl = supabaseClient.storage.from('avatars').getPublicUrl(imagePath);

      LoggerService.logger.i('Public URL obtained: $avatarUrl');

      // Update the user profile with the avatar URL
      final userUpdateResponse = await supabaseClient.from('profiles').upsert({
        'id': userId,
        'name': name,
        'avatar_url': avatarUrl, // Save the public URL in the database
      });

      LoggerService.logger.i('Updated User Profile: ${response}');
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      LoggerService.logger.e('Unknown error: $e');
      throw ServerException(e.toString());
    } catch (e) {
      LoggerService.logger.e('Unexpected error: $e');
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

      LoggerService.logger.i('auth data source of user: ${response.user!.toJson()}');
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      const webClientId = '908468362758-rdalsblfhdl2nbnh9bui78ubgmhdboi3.apps.googleusercontent.com';
      const iosClientId = '908468362758-m5a317hnbtj1ji5mqrrj30ehr34k9bs4.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'No Access Token or ID Token found.';
      }

      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on ServerException catch (e) {
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
  Future<void> recoverPassword({
    required String email,
  }) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
      LoggerService.logger.i(email);
    } on ServerException catch (e) {
      LoggerService.logger.e('$e');
      throw ServerException(e.toString());
    } catch (e) {
      LoggerService.logger.e(e.toString());
      throw ServerException(e.toString());
    }
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateUser({
    required String name,
    required String bio,
    String? avatarUrl, // Make the avatarUrl parameter optional
  }) async {
    try {
      final updateData = {
        'name': name,
        'bio': bio,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Include avatarUrl in the update data if provided
      if (avatarUrl != null) {
        updateData['avatar_url'] = avatarUrl;
      }

      final response = await supabaseClient
          .from(DBConstants.profilesTable)
          .update(updateData) // Use the update data containing avatarUrl if provided
          .eq('id', currentUserSession!.user.id)
          .select();

      final userJson = response.first;
      userJson['email'] = currentUserSession!.user.email;

      LoggerService.logger.d('Update response: $userJson');
      return UserModel.fromJson(userJson);
    } on AuthException catch (e) {
      LoggerService.logger.e(e.toString());
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<String> uploadProfileUserImage({
    File? image,
  }) async {
    try {
      final userId = currentUserSession!.user.id;
      final imagePath = '$userId/${DateTime.now().millisecondsSinceEpoch}';
      await supabaseClient.storage.from('avatars').upload(imagePath, image!);

      // Ensuring the file is available by fetching it or a simple delay could be introduced
      await Future.delayed(const Duration(seconds: 1)); // Example delay, adjust based on actual needs

      final url = supabaseClient.storage.from('avatars').getPublicUrl(imagePath);
      LoggerService.logger.i('Public URL obtained: $url');
      return url;
    } catch (e) {
      LoggerService.logger.e('Failed to upload image: ${e.toString()}');
      throw ServerException(e.toString());
    }
  }
}
