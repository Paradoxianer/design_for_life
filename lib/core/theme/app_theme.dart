import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors (Growth & Life)
  static const Color forestGreen = Color(0xFF2D5A27);
  static const Color earthBrown = Color(0xFF8B5E3C);
  static const Color sunlightGold = Color(0xFFF4D03F);
  
  // Background & Surface
  static const Color background = Color(0xFFF9F9F9);
  static const Color surface = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: forestGreen,
        primary: forestGreen,
        secondary: earthBrown,
        tertiary: sunlightGold,
        surface: surface,
      ),
      scaffoldBackgroundColor: background,
      
      // Typography
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: forestGreen,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      ),
      
      cardTheme: CardThemeData(
        color: surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
