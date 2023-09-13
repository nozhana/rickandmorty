import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.amber,
    primaryColor: Colors.amber.shade400,
    fontFamily: GoogleFonts.chakraPetch().fontFamily,
    splashColor: Colors.grey.shade200,
    highlightColor: Colors.transparent,
    dividerColor: Colors.grey[200],
    appBarTheme: _lightAppBarTheme(),
    floatingActionButtonTheme: _floatingActionButtonTheme(),
    colorScheme: _colorScheme(),
  );
}

ColorScheme _colorScheme() {
  return ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
          primaryColorDark: Colors.amber.shade700,
          backgroundColor: Colors.white,
          brightness: Brightness.light)
      .copyWith(
    onPrimary: Colors.black,
    onSecondary: Colors.grey[800],
    onTertiary: Colors.grey[700],
    primaryContainer: Colors.grey[100],
    secondaryContainer: Colors.grey[200],
    tertiaryContainer: Colors.grey[300],
    onPrimaryContainer: Colors.grey[900],
    onSecondaryContainer: Colors.grey[800],
    onTertiaryContainer: Colors.grey[800],
  );
}

FloatingActionButtonThemeData _floatingActionButtonTheme() {
  return FloatingActionButtonThemeData(
    backgroundColor: Colors.amber.shade500,
    foregroundColor: Colors.black,
    focusColor: Colors.amber.shade700,
    elevation: 4,
  );
}

AppBarTheme _lightAppBarTheme() {
  return AppBarTheme(
    color: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 0.0,
    shadowColor: Colors.transparent,
    scrolledUnderElevation: 0.0,
    centerTitle: false,
    iconTheme: const IconThemeData(color: Colors.black),
    toolbarHeight: kToolbarHeight + 24,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontFamily: GoogleFonts.chakraPetch().fontFamily,
      fontSize: 34,
      fontWeight: FontWeight.w600,
    ),
  );
}
