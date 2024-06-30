import 'package:flutter/material.dart';

void showFailSnackbar(BuildContext context, String content) {
  // Extract the relevant message from the error content
  final regex = RegExp(r'message: (.*?), statusCode');
  final match = regex.firstMatch(content);
  final message = match != null ? match.group(1) : content;
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
                message ?? 'An unknown error occured',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating, // This changes SnackBar to floating
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
        duration: const Duration(seconds: 2),
        elevation: 0,
      ),
    );
}
