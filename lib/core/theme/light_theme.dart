import 'package:evercook/core/theme/pallete/dark_pallete.dart';
import 'package:evercook/core/theme/pallete/light_pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightColorScheme = ColorScheme(
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

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: LightPallete.backgroundColor,
  textTheme: lightTextTheme,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFF9FAFA),
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    selectedItemColor: Color.fromARGB(255, 221, 56, 32),
    unselectedItemColor: Color(0xFFA7A7A7),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: LightPallete.backgroundColor,
    scrolledUnderElevation: 0,
    elevation: 0,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: LightPallete.backgroundColor,
    side: BorderSide.none,
  ),
  inputDecorationTheme: InputDecorationTheme(
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
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Color.fromARGB(255, 221, 56, 32),
    selectionColor: Color.fromARGB(255, 221, 56, 32).withOpacity(0.4),
    selectionHandleColor: Colors.red, // Custom selection handle color
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(221, 56, 32, 1),
    elevation: 0,
  ),
  dividerTheme: DividerThemeData(
    color: Color.fromARGB(255, 226, 226, 227),
    thickness: 0.8,
  ),
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
