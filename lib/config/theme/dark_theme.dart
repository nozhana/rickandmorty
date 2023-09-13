import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    cardColor: Colors.grey[900],
    scaffoldBackgroundColor: Colors.black,
    primarySwatch: Colors.amber,
    primaryColor: Colors.amber.shade800,
    fontFamily: GoogleFonts.chakraPetch().fontFamily,
    splashColor: Colors.grey.shade900,
    highlightColor: Colors.transparent,
    dividerColor: Colors.grey[900],
    floatingActionButtonTheme: _floatingActionButtonTheme(),
    appBarTheme: _darkAppBarTheme(),
    colorScheme: _colorScheme(),
  );
}

ColorScheme _colorScheme() {
  return ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
          primaryColorDark: Colors.amber.shade800,
          backgroundColor: Colors.black,
          brightness: Brightness.dark)
      .copyWith(
    onPrimary: Colors.white,
    onSecondary: Colors.grey[200],
    onTertiary: Colors.grey[300],
    primaryContainer: Colors.grey[900],
    secondaryContainer: Colors.grey[800],
    tertiaryContainer: Colors.grey[700],
    onPrimaryContainer: Colors.grey[100],
    onSecondaryContainer: Colors.grey[200],
    onTertiaryContainer: Colors.grey[200],
  );
}

FloatingActionButtonThemeData _floatingActionButtonTheme() {
  return FloatingActionButtonThemeData(
    backgroundColor: Colors.amber.shade700,
    foregroundColor: Colors.white,
    focusColor: Colors.amber.shade900,
    elevation: 4,
  );
}

AppBarTheme _darkAppBarTheme() {
  return AppBarTheme(
    color: Colors.black,
    surfaceTintColor: Colors.black,
    elevation: 0.0,
    shadowColor: Colors.transparent,
    scrolledUnderElevation: 0.0,
    centerTitle: false,
    iconTheme: const IconThemeData(color: Colors.white),
    toolbarHeight: kToolbarHeight + 24,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontFamily: GoogleFonts.chakraPetch().fontFamily,
      fontSize: 34,
      fontWeight: FontWeight.w600,
    ),
  );
}
