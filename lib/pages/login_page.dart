import 'package:evercook/controller/login_controller.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final LoginController _loginController = LoginController();

  LoginPage({super.key});

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
              controller: _loginController.emailController,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                _loginController.signInWithEmail();
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                _loginController.signInWithGoogle();
              },
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
