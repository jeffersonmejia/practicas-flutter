import 'package:flutter/material.dart';

class AppTheme {

  // azul muy suave para fondo de botones
  static const Color softBlue = Color.fromRGBO(232, 240, 254, 1);

  // azul moderado para texto e iconos
  static const Color strongBlue = Color.fromRGBO(66, 133, 244, 1);

  static const Color borderColor = Color(0xFFE6EAF0);

  static final ThemeData lightTheme = ThemeData(

    useMaterial3: true,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: strongBlue,
      onPrimary: Colors.white,
      secondary: strongBlue,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black87,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),

    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      centerTitle: true,
    ),

    iconTheme: const IconThemeData(
      size: 22,
      color: borderColor,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(softBlue),
        foregroundColor: const WidgetStatePropertyAll(strongBlue),
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 48)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(softBlue),
        foregroundColor: const WidgetStatePropertyAll(strongBlue),
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 48)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        side: const WidgetStatePropertyAll(BorderSide.none),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: borderColor),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      prefixIconColor: borderColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: strongBlue, width: 1),
      ),
    ),
  );
}