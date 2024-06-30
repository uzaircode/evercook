import 'package:evercook/core/theme/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightPallete {
  static const primaryColor = Color.fromARGB(255, 221, 56, 32);
  static const whiteColor = Color(0xFFFFFFFF);
  static const borderColor = Color(0xFFE0E0E0);
  static const greyColor = Color(0xFF9E9E9E);
  static const errorColor = Color(0xFFB00020);
  static const backgroundColor = Color.fromARGB(255, 255, 255, 255);
}

class DarkPallete {
  static const primaryColor = Color.fromARGB(255, 221, 56, 32);
  static const gradient1 = Color(0xFF1A237E);
  static const whiteColor = Color(0xFFFFFFFF);
  static const backgroundColor = Color.fromARGB(255, 28, 28, 30);
  static const errorColor = Color(0xFFB00020);
  static const greyColor = Color(0xFFB0BEC5);
}

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: LightPallete.backgroundColor,
  textTheme: lightTextTheme,
  bottomNavigationBarTheme: lightBottomNavigationBarTheme,
  appBarTheme: lightAppBarTheme,
  chipTheme: lightChipTheme,
  inputDecorationTheme: lightInputDecorationTheme,
  textSelectionTheme: lightTextSelectionTheme,
  floatingActionButtonTheme: lightFloatingActionButtonTheme,
  dividerTheme: lightDividerTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        DarkPallete.backgroundColor,
      ),
      foregroundColor: WidgetStateProperty.all(
        Color.fromARGB(255, 245, 245, 245),
      ),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: DarkPallete.backgroundColor,
  textTheme: darkTextTheme,
  bottomNavigationBarTheme: darkBottomNavigationBarTheme,
  appBarTheme: darkAppBarTheme,
  chipTheme: darkChipTheme,
  inputDecorationTheme: darkInputDecorationTheme,
  textSelectionTheme: darkTextSelectionTheme,
  floatingActionButtonTheme: darkFloatingActionButtonTheme,
  dividerTheme: darkDividerTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
      foregroundColor: WidgetStateProperty.all(Color.fromARGB(255, 49, 49, 53)),
    ),
  ),
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: LightPallete.whiteColor,
  onPrimary: Color.fromARGB(255, 49, 49, 53),
  secondary: Color.fromARGB(255, 166, 166, 166),
  onSecondary: Color.fromARGB(255, 166, 166, 166),
  primaryContainer: Color.fromARGB(255, 224, 224, 224),
  onPrimaryContainer: Color.fromARGB(255, 224, 224, 224),
  secondaryContainer: Color.fromARGB(255, 224, 224, 224),
  onSecondaryContainer: Color.fromARGB(255, 224, 224, 224),
  tertiary: Color.fromARGB(255, 244, 244, 244), //appbar
  onTertiary: Color.fromARGB(255, 122, 122, 122), //appbar
  error: LightPallete.errorColor,
  onError: Colors.white,
  errorContainer: LightPallete.errorColor,
  onErrorContainer: Colors.white,
  background: LightPallete.backgroundColor,
  onBackground: Colors.black,
  surface: LightPallete.whiteColor,
  onSurface: LightPallete.whiteColor,
  surfaceVariant: LightPallete.borderColor,
  onSurfaceVariant: LightPallete.greyColor,
  outline: LightPallete.greyColor,
  outlineVariant: LightPallete.borderColor,
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Colors.white,
  inversePrimary: LightPallete.borderColor,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: DarkPallete.backgroundColor,
  onPrimary: Color.fromARGB(255, 232, 232, 233),
  primaryContainer: Color.fromARGB(255, 81, 81, 83),
  onPrimaryContainer: Color.fromARGB(255, 81, 81, 83),
  secondary: Color.fromARGB(255, 166, 166, 166),
  onSecondary: Color.fromARGB(255, 166, 166, 166),
  secondaryContainer: Color.fromARGB(255, 38, 38, 40),
  onSecondaryContainer: Color.fromARGB(255, 38, 38, 40),
  tertiary: Color.fromARGB(255, 41, 41, 43), //appbar
  onTertiary: Color.fromARGB(255, 197, 197, 197), //appbar
  error: DarkPallete.errorColor,
  onError: DarkPallete.whiteColor,
  errorContainer: DarkPallete.errorColor,
  onErrorContainer: DarkPallete.whiteColor,
  background: DarkPallete.backgroundColor,
  onBackground: DarkPallete.whiteColor,
  surface: Color.fromARGB(255, 41, 41, 43), //sheets/cards/menus
  onSurface: Color.fromARGB(255, 168, 168, 169), //sheets/cards/menus
  surfaceVariant: DarkPallete.greyColor,
  onSurfaceVariant: DarkPallete.greyColor,
  outline: DarkPallete.greyColor,
  outlineVariant: DarkPallete.greyColor,
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: DarkPallete.greyColor,
  inversePrimary: DarkPallete.gradient1,
);

final lightTextTheme = TextTheme(
  headlineMedium: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color(0xFF3F3F3F),
    overflow: TextOverflow.ellipsis,
  ),
  titleLarge: GoogleFonts.notoSerif(
    textStyle: TextStyle(
      color: Color.fromARGB(255, 64, 64, 64),
      fontSize: 35,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
  ),
  titleMedium: TextStyle(
    color: Color(0xFF404040),
    fontWeight: FontWeight.w600,
    fontSize: 20,
  ),
  titleSmall: GoogleFonts.inter(
    textStyle: TextStyle(
      color: Color(0xFF3F3F3F),
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 1.5,
    ),
  ),
  bodyMedium: TextStyle(
    fontSize: 16,
    color: Color(0xFF7F7F7F),
    fontWeight: FontWeight.w500,
  ),
  bodySmall: TextStyle(
    color: Colors.grey[600],
    fontSize: 14,
  ),
);

final darkTextTheme = TextTheme(
  headlineMedium: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 232, 232, 233),
    overflow: TextOverflow.ellipsis,
  ),
  titleMedium: TextStyle(
    color: Color.fromARGB(255, 232, 232, 233),
    fontWeight: FontWeight.w600,
    fontSize: 20,
  ),
  titleLarge: GoogleFonts.notoSerif(
    textStyle: TextStyle(
      color: Color.fromARGB(255, 232, 232, 233),
      fontSize: 35,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
  ),
  titleSmall: GoogleFonts.inter(
    textStyle: TextStyle(
      color: Color.fromARGB(255, 232, 232, 233),
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 1.5,
    ),
  ),
  bodySmall: TextStyle(
    color: Color.fromARGB(255, 166, 166, 166),
    fontSize: 14,
  ),
  bodyMedium: TextStyle(
    fontSize: 16,
    color: Color(0xFFE7E7E9),
    fontWeight: FontWeight.w500,
  ),
);

final lightBottomNavigationBarTheme = BottomNavigationBarThemeData(
  backgroundColor: Color(0xFFF9FAFA),
  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  selectedItemColor: Color.fromARGB(255, 221, 56, 32),
  unselectedItemColor: Color(0xFFA7A7A7),
);

final darkBottomNavigationBarTheme = BottomNavigationBarThemeData(
  backgroundColor: Color.fromARGB(255, 34, 34, 36),
  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  selectedItemColor: Color.fromRGBO(221, 56, 32, 1),
  unselectedItemColor: Color.fromARGB(255, 167, 167, 167),
);

final lightAppBarTheme = AppBarTheme(
  backgroundColor: LightPallete.backgroundColor,
  scrolledUnderElevation: 0,
  elevation: 0,
);

final darkAppBarTheme = AppBarTheme(
  backgroundColor: DarkPallete.backgroundColor,
  scrolledUnderElevation: 0,
  elevation: 0,
);

final lightChipTheme = ChipThemeData(
  backgroundColor: LightPallete.backgroundColor,
  side: BorderSide.none,
);

final darkChipTheme = ChipThemeData(
  backgroundColor: DarkPallete.backgroundColor,
  side: BorderSide.none,
);

final lightInputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: Color.fromARGB(255, 242, 244, 245),
  contentPadding: EdgeInsets.all(16),
  hintStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Color.fromARGB(255, 132, 131, 137),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 221, 56, 32),
    ), // Set your desired color for enabled state
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: LightPallete.errorColor),
  ),
);

final darkInputDecorationTheme = InputDecorationTheme(
  filled: true,
  contentPadding: EdgeInsets.all(16),
  fillColor: Color.fromARGB(255, 49, 49, 53),
  hintStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Colors.grey[500],
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 221, 56, 32),
    ), // Set your desired color for enabled state
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: DarkPallete.errorColor),
  ),
);

final lightTextSelectionTheme = TextSelectionThemeData(
  cursorColor: Color.fromARGB(255, 221, 56, 32),
  selectionColor: Color.fromARGB(255, 221, 56, 32).withOpacity(0.4),
  selectionHandleColor: Colors.red, // Custom selection handle color
);

final darkTextSelectionTheme = TextSelectionThemeData(
  cursorColor: Color.fromARGB(255, 221, 56, 32),
  selectionColor: Color.fromARGB(255, 221, 56, 32).withOpacity(0.4),
  selectionHandleColor: Colors.red, // Custom selection handle color
);

final lightFloatingActionButtonTheme = FloatingActionButtonThemeData(
  backgroundColor: Color.fromRGBO(221, 56, 32, 1),
  elevation: 0,
);

final darkFloatingActionButtonTheme = FloatingActionButtonThemeData(
  backgroundColor: Color(0xFFDD3820),
  elevation: 0,
);

final lightDividerTheme = DividerThemeData(
  color: Color.fromARGB(255, 226, 226, 227),
  thickness: 0.8,
);

final darkDividerTheme = DividerThemeData(
  color: Color.fromARGB(255, 60, 60, 63),
  thickness: 0.8,
);

final Color lightProfilePageBackgroundColor = Color.fromARGB(255, 245, 245, 245);
final Color darkProfilePageBackgroundColor = DarkPallete.backgroundColor;

final profilePageTheme = {
  CustomThemeMode.light: lightProfilePageBackgroundColor,
  CustomThemeMode.dark: darkProfilePageBackgroundColor,
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

// const lightColorScheme = ColorScheme(
//   tertiary: Color.fromARGB(255, 244, 244, 244), //appbar
//   onTertiary: Color.fromARGB(255, 122, 122, 122), //appbar

//   const darkColorScheme = ColorScheme(
//   tertiary: Color.fromARGB(255, 41, 41, 43), //appbar
//   onTertiary: Color.fromARGB(255, 197, 197, 197), //appbar

class PinkPallete {
  static const primaryColor = Color.fromARGB(255, 255, 77, 109);
  static const whiteColor = Color(0xFFFFFFFF);
  static const backgroundColor = Color(0xFFFCE4EC);
  static const errorColor = Color(0xFFB00020);
  static const greyColor = Color(0xFFB0BEC5);
}

final Color pinkProfilePageBackgroundColor = PinkPallete.backgroundColor;
final Color pinkInputFillColor = Color(0xFFF8BBD0);
final Color pinkButtonBackgroundColor = PinkPallete.primaryColor;
final Color pinkButtonTextColor = PinkPallete.whiteColor;
final Color pinkBoxDecorationColor = Color(0xFFF8BBD0);
final Color pinkBackgroundIcon = Color(0xFFF8BBD0);
final Color pinkIconColor = Color(0xFFE91E63);

ThemeData pinkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: pinkColorScheme,
  scaffoldBackgroundColor: PinkPallete.backgroundColor,
  textTheme: pinkTextTheme,
  bottomNavigationBarTheme: pinkBottomNavigationBarTheme,
  appBarTheme: pinkAppBarTheme,
  chipTheme: pinkChipTheme,
  inputDecorationTheme: pinkInputDecorationTheme,
  textSelectionTheme: pinkTextSelectionTheme,
  floatingActionButtonTheme: pinkFloatingActionButtonTheme,
  dividerTheme: pinkDividerTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(pinkProfilePageBackgroundColor),
      foregroundColor: MaterialStateProperty.all(pinkProfilePageBackgroundColor),
    ),
  ),
);

const pinkColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: PinkPallete.primaryColor,
  onPrimary: Color.fromARGB(255, 255, 255, 255),
  secondary: Color.fromARGB(255, 255, 182, 193),
  onSecondary: Color.fromARGB(255, 255, 182, 193),
  primaryContainer: Color.fromARGB(255, 255, 228, 225),
  onPrimaryContainer: Color.fromARGB(255, 255, 228, 225),
  secondaryContainer: Color.fromARGB(255, 255, 228, 225),
  onSecondaryContainer: Color.fromARGB(255, 255, 228, 225),
  tertiary: Color.fromARGB(255, 255, 240, 245),
  onTertiary: Color.fromARGB(255, 255, 105, 180),
  error: PinkPallete.errorColor,
  onError: Colors.white,
  errorContainer: PinkPallete.errorColor,
  onErrorContainer: Colors.white,
  background: PinkPallete.backgroundColor,
  onBackground: Colors.black,
  surface: PinkPallete.whiteColor,
  onSurface: PinkPallete.whiteColor,
  surfaceVariant: PinkPallete.greyColor,
  onSurfaceVariant: PinkPallete.greyColor,
  outline: PinkPallete.greyColor,
  outlineVariant: PinkPallete.greyColor,
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Colors.white,
  inversePrimary: PinkPallete.primaryColor,
);

final pinkTextTheme = TextTheme(
  headlineMedium: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color(0xFF3F3F3F),
    overflow: TextOverflow.ellipsis,
  ),
  titleLarge: GoogleFonts.notoSerif(
    textStyle: TextStyle(
      color: Color.fromARGB(255, 64, 64, 64),
      fontSize: 35,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
  ),
  titleMedium: TextStyle(
    color: Color(0xFF404040),
    fontWeight: FontWeight.w600,
    fontSize: 20,
  ),
  titleSmall: GoogleFonts.inter(
    textStyle: TextStyle(
      color: Color(0xFF3F3F3F),
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 1.5,
    ),
  ),
  bodyMedium: TextStyle(
    fontSize: 16,
    color: Color(0xFF7F7F7F),
    fontWeight: FontWeight.w500,
  ),
  bodySmall: TextStyle(
    color: Colors.grey[600],
    fontSize: 14,
  ),
);

final pinkBottomNavigationBarTheme = BottomNavigationBarThemeData(
  backgroundColor: Color(0xFFFCE4EC),
  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  selectedItemColor: Color(0xFFE91E63),
  unselectedItemColor: Color(0xFFA7A7A7),
);

final pinkAppBarTheme = AppBarTheme(
  backgroundColor: PinkPallete.backgroundColor,
  scrolledUnderElevation: 0,
  elevation: 0,
);

final pinkChipTheme = ChipThemeData(
  backgroundColor: PinkPallete.backgroundColor,
  side: BorderSide.none,
);

final pinkInputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: Color(0xFFF8BBD0),
  contentPadding: EdgeInsets.all(16),
  hintStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Color.fromARGB(255, 132, 131, 137),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(
      color: Color(0xFFE91E63),
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: PinkPallete.errorColor),
  ),
);

final pinkTextSelectionTheme = TextSelectionThemeData(
  cursorColor: Color(0xFFE91E63),
  selectionColor: Color(0xFFE91E63).withOpacity(0.4),
  selectionHandleColor: Colors.red,
);

final pinkFloatingActionButtonTheme = FloatingActionButtonThemeData(
  backgroundColor: Color(0xFFE91E63),
  elevation: 0,
);

final pinkDividerTheme = DividerThemeData(
  color: Color.fromARGB(255, 226, 226, 227),
  thickness: 0.8,
);
