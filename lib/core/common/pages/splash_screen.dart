import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 167, 182),
      body: Center(
        child: Image.asset('assets/images/evercook_splash_screen.png'),
      ),
    );
  }
}
