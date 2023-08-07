import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.amber,
    fontFamily: "GigaSans",
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    appBarTheme: _appBarTheme(),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber)
        .copyWith(background: Colors.white),
  );
}

AppBarTheme _appBarTheme() {
  return const AppBarTheme(
    color: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 0.0,
    shadowColor: Colors.transparent,
    scrolledUnderElevation: 0.0,
    centerTitle: false,
    iconTheme: IconThemeData(color: Colors.grey),
    toolbarHeight: kToolbarHeight + 24,
    titleTextStyle: TextStyle(
      color: Colors.white38,
      height: 3,
      fontFamily: "GigaSans",
      fontSize: 34,
      fontWeight: FontWeight.w600,
    ),
  );
}
