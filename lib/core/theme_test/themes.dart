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
      backgroundColor: WidgetStateProperty.all(lightButtonBackgroundColor),
      foregroundColor: WidgetStateProperty.all(lightButtonTextColor),
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
      backgroundColor: WidgetStateProperty.all(darkButtonBackgroundColor),
      foregroundColor: WidgetStateProperty.all(darkButtonTextColor),
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
  Brightness.light: lightProfilePageBackgroundColor,
  Brightness.dark: darkProfilePageBackgroundColor,
};

// Fill colors for InputDecoration
final Color lightInputFillColor = Color.fromARGB(255, 245, 245, 245);
final Color darkInputFillColor = Color.fromARGB(255, 49, 49, 53);

final inputFillColorTheme = {
  Brightness.light: lightInputFillColor,
  Brightness.dark: darkInputFillColor,
};

// Define button colors
final Color lightButtonBackgroundColor = DarkPallete.backgroundColor;
final Color lightButtonTextColor = Color.fromARGB(255, 245, 245, 245);
final Color darkButtonBackgroundColor = Colors.white; // Adjust as needed
final Color darkButtonTextColor = Color.fromARGB(255, 49, 49, 53);

// Box decoration colors
final Color lightBoxDecorationColor = Colors.white;
final Color darkBoxDecorationColor = Color.fromARGB(255, 38, 38, 40);

final boxDecorationColorTheme = {
  Brightness.light: lightBoxDecorationColor,
  Brightness.dark: darkBoxDecorationColor,
};

final Color lightBackgroundIcon = Color.fromARGB(255, 224, 224, 224);
final Color lightIconColor = Color.fromARGB(255, 122, 122, 122);

final Color darkBackgroundIcon = Color.fromARGB(255, 41, 41, 43);
final Color darkIconColor = Color.fromARGB(255, 197, 197, 197);

final appBarBackgroundIconTheme = {
  Brightness.light: lightBackgroundIcon,
  Brightness.dark: darkBackgroundIcon,
};

final appBarIconTheme = {
  Brightness.light: lightIconColor,
  Brightness.dark: darkIconColor,
};

// const lightColorScheme = ColorScheme(
//   tertiary: Color.fromARGB(255, 244, 244, 244), //appbar
//   onTertiary: Color.fromARGB(255, 122, 122, 122), //appbar

//   const darkColorScheme = ColorScheme(
//   tertiary: Color.fromARGB(255, 41, 41, 43), //appbar
//   onTertiary: Color.fromARGB(255, 197, 197, 197), //appbar