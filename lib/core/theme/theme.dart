import 'package:evercook/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final themeData = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      elevation: 0,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppPallete.backgroundColor,
      side: BorderSide.none,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
    ),
  );
}
