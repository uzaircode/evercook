import 'package:evercook/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = const Color.fromARGB(255, 230, 230, 234)]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      );

  static final themeData = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      scrolledUnderElevation: 0,
      elevation: 0,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppPallete.backgroundColor,
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      errorBorder: _border(AppPallete.errorColor),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color.fromARGB(255, 244, 118, 160),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color.fromARGB(255, 244, 118, 160),
      elevation: 0,
    ),
  );
}
