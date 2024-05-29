import 'package:flutter/material.dart';

// ? this one too, loader? give me something else!!!
class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: const Color.fromARGB(255, 221, 56, 32),
      ),
    );
  }
}
