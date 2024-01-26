import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 35,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      minimumSize: const Size.fromHeight(52),
      backgroundColor: Colors.blue,
    ),
  ),
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade200,
    primary: Colors.grey.shade100,
    secondary: Colors.blue,
    surface: Colors.white,
    onBackground: Colors.black,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
);

ThemeData darkMode = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 35,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      minimumSize: const Size.fromHeight(52),
      backgroundColor: Colors.grey.shade800,
    ),
  ),
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.blue,
    surface: Colors.grey.shade800,
    onBackground: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
);
