import 'package:evercook/core/theme/pallete/pink_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final pinkColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: PinkPallete.backgroundColor,
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

final pinkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: pinkColorScheme,
  scaffoldBackgroundColor: PinkPallete.backgroundColor,
  textTheme: pinkTextTheme,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFCE4EC),
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    selectedItemColor: Color(0xFFE91E63),
    unselectedItemColor: Color.fromARGB(255, 255, 179, 193),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: PinkPallete.backgroundColor,
    scrolledUnderElevation: 0,
    elevation: 0,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: PinkPallete.backgroundColor,
    side: BorderSide.none,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF8BBD0),
    contentPadding: EdgeInsets.all(16),
    hintStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: Color(0xFFFFEBEE),
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
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Color(0xFFE91E63),
    selectionColor: Color(0xFFE91E63).withOpacity(0.4),
    selectionHandleColor: Colors.red,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFE91E63),
    elevation: 0,
  ),
  dividerTheme: DividerThemeData(
    color: Color.fromARGB(255, 255, 182, 193),
    thickness: 0.8,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(PinkPallete.primaryColor),
      foregroundColor: WidgetStateProperty.all(PinkPallete.whiteColor),
    ),
  ),
);
