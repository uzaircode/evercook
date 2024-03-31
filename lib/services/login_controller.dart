import 'package:evercook/main.dart';
import 'package:evercook/pages/account_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void signInWithEmail() async {
    try {
      final email = emailController.text.trim();
      await supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      Get.snackbar('Success', 'Check your inbox');
    } on AuthException catch (error) {
      Get.snackbar('Error', error.message, backgroundColor: Colors.red);
    }
  }

  void signInWithGoogle() async {
    const webClientId = '821209992543-484e5sgfn35qtu15vl5rjo2tojg87fci.apps.googleusercontent.com';
    const iosClientId = '821209992543-oiriijeemriiash1lg1bl4ncf5bc717n.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    final result = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (result.user != null) {
      Get.offAll(() => AccountPage());
    } else {
      Get.snackbar('Login Error', 'Failed to sign in with Google');
    }
  }
}
