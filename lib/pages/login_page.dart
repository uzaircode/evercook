import 'dart:async';

import 'package:evercook/main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authSubscription;
  String? _userId;

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                try {
                  final email = _emailController.text.trim();
                  await supabase.auth.signInWithOtp(
                    email: email,
                    emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Check your inbox'),
                      ),
                    );
                  }
                } on AuthException catch (error) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.message),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
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

                await supabase.auth.signInWithIdToken(
                  provider: OAuthProvider.google,
                  idToken: idToken,
                  accessToken: accessToken,
                );
              },
              child: Text('Sign in with Google'),
            )
          ],
        ),
      ),
    );
  }
}
