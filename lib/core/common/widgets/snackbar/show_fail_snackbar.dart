import 'package:flutter/material.dart';

void showFailSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.cancel_outlined, color: Colors.white), // Tick icon
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
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating, // This changes SnackBar to floating
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
        duration: const Duration(seconds: 3),
        elevation: 0,
      ),
    );
}