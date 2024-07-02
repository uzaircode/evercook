import 'package:evercook/core/theme/pallete/dark_pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkColorScheme = ColorScheme(
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

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: DarkPallete.backgroundColor,
  textTheme: darkTextTheme,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 34, 34, 36),
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    selectedItemColor: Color.fromRGBO(221, 56, 32, 1),
    unselectedItemColor: Color.fromARGB(255, 167, 167, 167),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: DarkPallete.backgroundColor,
    scrolledUnderElevation: 0,
    elevation: 0,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: DarkPallete.backgroundColor,
    side: BorderSide.none,
  ),
  inputDecorationTheme: InputDecorationTheme(
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
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Color.fromARGB(255, 221, 56, 32),
    selectionColor: Color.fromARGB(255, 221, 56, 32).withOpacity(0.4),
    selectionHandleColor: Colors.red, // Custom selection handle color
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFDD3820),
    elevation: 0,
  ),
  dividerTheme: DividerThemeData(
    color: Color.fromARGB(255, 60, 60, 63),
    thickness: 0.8,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
      foregroundColor: WidgetStateProperty.all(Color.fromARGB(255, 49, 49, 53)),
    ),
  ),
);
