import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//todo - standardize this color const red - Color.fromARGB(255, 221, 56, 32),
class LightPallete {
  static const Color backgroundColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color gradient1 = Color.fromRGBO(187, 63, 221, 1);
  static const Color gradient2 = Color.fromRGBO(251, 109, 169, 1);
  static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);
  static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  static const Color errorColor = Colors.redAccent;
  static const Color transparentColor = Colors.transparent;
}

class DarkPallete {
  static const Color backgroundColor = Color.fromARGB(255, 34, 34, 36);
  static const Color gradient1 = Color.fromARGB(255, 255, 255, 255);
  static const Color gradient2 = Color.fromARGB(255, 255, 255, 255);
  static const Color gradient3 = Color.fromARGB(255, 255, 255, 255);
  static const Color borderColor = Color.fromARGB(255, 105, 255, 24);
  static const Color whiteColor = Color.fromARGB(255, 255, 255, 255);
  static const Color greyColor = Color.fromARGB(255, 167, 167, 167);
  static const Color errorColor = Color.fromARGB(255, 105, 255, 24);
  static const Color transparentColor = Colors.transparent;
}

class Themes {
  static OutlineInputBorder _border([Color color = LightPallete.borderColor]) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color));

  static final light = ThemeData(
    colorScheme: ColorScheme.light(
      primary: LightPallete.gradient1,
      onPrimary: LightPallete.whiteColor,
      primaryContainer: LightPallete.backgroundColor,
      onPrimaryContainer: LightPallete.borderColor,
      secondary: LightPallete.greyColor,
      error: LightPallete.errorColor,
      onError: LightPallete.errorColor,
      background: LightPallete.backgroundColor,
      onBackground: LightPallete.greyColor,
      surface: LightPallete.whiteColor,
      onSurface: LightPallete.borderColor,
    ),
    scaffoldBackgroundColor: LightPallete.backgroundColor,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.notoSerif(
        textStyle: TextStyle(
          color: Color.fromARGB(255, 64, 64, 64),
          fontSize: 35,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      // titleSmall: TextStyle(
      //   color: Color.fromARGB(255, 63, 63, 63),
      //   fontWeight: FontWeight.bold,
      //   fontSize: 16,
      //   height: 1.5,
      // ),
      titleSmall: GoogleFonts.inter(
        textStyle: TextStyle(
          color: Color.fromARGB(255, 63, 63, 63),
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.5,
        ),
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 127, 127, 127),
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 249, 250, 250),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      selectedItemColor: Color.fromARGB(255, 221, 56, 32),
      unselectedItemColor: Color.fromARGB(255, 167, 167, 167),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: LightPallete.backgroundColor,
      scrolledUnderElevation: 0,
      elevation: 0,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: LightPallete.backgroundColor,
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      hintStyle: TextStyle(fontSize: 16, color: Colors.grey[500]),
      errorBorder: _border(LightPallete.errorColor),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color.fromARGB(255, 221, 56, 32),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 221, 56, 32),
      elevation: 0,
    ),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: DarkPallete.gradient1,
      onPrimary: DarkPallete.whiteColor,
      primaryContainer: DarkPallete.backgroundColor,
      onPrimaryContainer: DarkPallete.gradient1,
      secondary: DarkPallete.whiteColor,
      error: DarkPallete.errorColor,
      onError: DarkPallete.errorColor,
      background: DarkPallete.backgroundColor,
      onBackground: DarkPallete.gradient1,
      surface: DarkPallete.whiteColor,
      onSurface: DarkPallete.greyColor,
    ),
    scaffoldBackgroundColor: DarkPallete.backgroundColor,
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      scaffoldBackgroundColor: Colors.amber,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: Color.fromARGB(255, 113, 113, 115),
        fontSize: 14,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 231, 231, 233), // Change this color for dark theme
        fontWeight: FontWeight.w500,
      ),
    ),
    brightness: Brightness.dark,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DarkPallete.backgroundColor,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      selectedItemColor: Color.fromARGB(255, 221, 56, 32),
      unselectedItemColor: Color.fromARGB(255, 167, 167, 167),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 221, 56, 32),
      elevation: 0,
    ),
  );
}
