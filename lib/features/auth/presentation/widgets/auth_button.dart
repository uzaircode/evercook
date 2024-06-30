import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isReversed; // Add this parameter

  const AuthButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isReversed = false, // Default is not reversed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isReversed ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36),
          side: isReversed ? BorderSide(color: Color.fromARGB(255, 186, 185, 185)) : BorderSide.none,
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 18,
          color: isReversed ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
