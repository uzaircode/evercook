import 'package:evercook/core/theme/bloc/theme_bloc.dart';
import 'package:evercook/core/theme/pallete/dark_pallete.dart';
import 'package:flutter/material.dart';

final Color pinkProfilePageBackgroundColor = Color(0xFFFCE4EC);
final Color pinkInputFillColor = Color(0xFFFFEBEE);
final Color pinkButtonBackgroundColor = Color(0xFFE91E63);
final Color pinkButtonTextColor = Color(0xFFFFFFFF);
final Color pinkBoxDecorationColor = Color(0xFFFFCDD2);
final Color pinkBackgroundIcon = Color(0xFFFFEBEE);
final Color pinkIconColor = Color(0xFFE91E63);

final profilePageTheme = {
  CustomThemeMode.light: Color.fromARGB(255, 245, 245, 245),
  CustomThemeMode.dark: DarkPallete.backgroundColor,
  CustomThemeMode.pink: pinkProfilePageBackgroundColor,
};

final dividerPageTheme = {
  CustomThemeMode.light: Color.fromARGB(255, 226, 227, 227),
  CustomThemeMode.dark: Color(0xFF3F3F3F),
  CustomThemeMode.pink: pinkProfilePageBackgroundColor,
};

// Fill colors for InputDecoration
final inputFillColorTheme = {
  CustomThemeMode.light: Color.fromARGB(255, 245, 245, 245),
  CustomThemeMode.dark: Color.fromARGB(255, 49, 49, 53),
  CustomThemeMode.pink: pinkInputFillColor,
};

// Define button colors
final buttonBackgroundColorTheme = {
  CustomThemeMode.light: DarkPallete.backgroundColor,
  CustomThemeMode.dark: Colors.white,
  CustomThemeMode.pink: pinkButtonBackgroundColor,
};

final buttonTextColorTheme = {
  Brightness.light: Color.fromARGB(255, 245, 245, 245),
  Brightness.dark: Color.fromARGB(255, 49, 49, 53),
  CustomThemeMode.pink: pinkButtonTextColor,
};

// Box decoration colors
final boxDecorationColorTheme = {
  CustomThemeMode.light: Colors.white,
  CustomThemeMode.dark: Color.fromARGB(255, 38, 38, 40),
  CustomThemeMode.pink: pinkBoxDecorationColor,
};

// Background icon colors
final appBarBackgroundIconTheme = {
  CustomThemeMode.light: Color.fromARGB(255, 224, 224, 224),
  CustomThemeMode.dark: Color.fromARGB(255, 41, 41, 43),
  CustomThemeMode.pink: pinkBackgroundIcon,
};

// Icon colors
final appBarIconTheme = {
  CustomThemeMode.light: Color.fromARGB(255, 122, 122, 122),
  CustomThemeMode.dark: Color.fromARGB(255, 197, 197, 197),
  CustomThemeMode.pink: pinkIconColor,
};
final themeSpecificColors = {
  CustomThemeMode.light: Color.fromARGB(255, 221, 56, 32),
  CustomThemeMode.dark: Color.fromARGB(255, 221, 56, 32),
  CustomThemeMode.pink: Color(0xFFF8BBD0),
};
