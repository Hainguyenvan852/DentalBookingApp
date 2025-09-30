import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed:  const Color(0xFFF55050),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white
      )
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
        textStyle: TextStyle(
          color: Colors.white,
        )
      )
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.lato(
        fontSize: 40,
      ),
      displayMedium: TextStyle(
        fontSize: 30,
      ),
      displaySmall: TextStyle(
        fontSize: 18,
      ),
    )
  );
}