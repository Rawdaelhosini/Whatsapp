import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WhatsAppTheme {
  static const Color primaryGreen = Color(0xFF075E54);
  static const Color lightGreen = Color(0xFF25D366);
  static const Color darkGreen = Color(0xFF128C7E);
  static const Color tealGreen = Color(0xFF34B7F1);

  // Light theme colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F8FA);
  static const Color lightBubbleSent = Color(0xFFDCF8C6);
  static const Color lightBubbleReceived = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF667781);
  static const Color lightContainer = Color(0xFFf6f5f3);
  static const Color lightSelected = Color(0xFFd8fdd2);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF0a0a0a);
  static const Color darkSurface = Color(0xFF202C33);
  static const Color darkBubbleSent = Color(0xFF005C4B);
  static const Color darkBubbleReceived = Color(0xFF202C33);
  static const Color darkText = Color(0xFFE9EDEF);
  static const Color darkTextSecondary = Color(0xFF8696A0);
  static const Color darkContainer = Color(0xFF222222);
  static const Color darkSelected = Color(0xFF103629);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: MaterialColor(0xFF075E54, const {
      50: Color(0xFFE0F2F1),
      100: Color(0xFFB2DFDB),
      200: Color(0xFF80CBC4),
      300: Color(0xFF4DB6AC),
      400: Color(0xFF26A69A),
      500: Color(0xFF075E54),
      600: Color(0xFF00695C),
      700: Color(0xFF00695C),
      800: Color(0xFF004D40),
      900: Color(0xFF004D40),
    }),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightBackground,
      selectedItemColor: primaryGreen,
      unselectedItemColor: lightTextSecondary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(0xFF075E54, const {
      50: Color(0xFFE0F2F1),
      100: Color(0xFFB2DFDB),
      200: Color(0xFF80CBC4),
      300: Color(0xFF4DB6AC),
      400: Color(0xFF26A69A),
      500: Color(0xFF075E54),
      600: Color(0xFF00695C),
      700: Color(0xFF00695C),
      800: Color(0xFF004D40),
      900: Color(0xFF004D40),
    }),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkText,
      elevation: 4,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkBackground,
      selectedItemColor: lightGreen,
      unselectedItemColor: darkTextSecondary,
    ),
  );
}
