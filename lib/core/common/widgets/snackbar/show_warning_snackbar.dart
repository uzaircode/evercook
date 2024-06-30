import 'package:flutter/material.dart';

void showWarningSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white), // Tick icon
            SizedBox(width: 8), // Space between icon and text
            Expanded(
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ), // To ensure text does not overflow
          ],
        ),
        backgroundColor: Colors.yellow,
        behavior: SnackBarBehavior.floating, // This changes SnackBar to floating
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
        duration: const Duration(seconds: 2),
        elevation: 0,
      ),
    );
}
