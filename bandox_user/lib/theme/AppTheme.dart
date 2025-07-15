import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AppColors.dart';

ThemeData appTheme = ThemeData(
  useMaterial3: true,

  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    error: AppColors.error,
    onError: AppColors.onError,
  ),

  scaffoldBackgroundColor: AppColors.background,

  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.text,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      color: AppColors.text,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      color: AppColors.text,
    ),
  ),

  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.text,
    centerTitle: true,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),
  ),

  cardTheme: CardTheme(
    color: AppColors.surface,
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    disabledBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
          color: AppColors.primary, style: BorderStyle.solid,width: 2.0
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:  const BorderSide(
          color: AppColors.primary, style: BorderStyle.solid,width: 2.0
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:  const BorderSide(
          color: AppColors.primary, style: BorderStyle.solid,width: 2.0
      ),
    ),
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:  const BorderSide(
          color: AppColors.primary, style: BorderStyle.solid,width: 2.0
      ),
    ),
    hintStyle: TextStyle(
      color: AppColors.text.withOpacity(0.6),
      fontSize: 14,
    ),
    labelStyle: const TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w500,
    ),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
  ),

  dividerTheme: DividerThemeData(
    color: AppColors.text.withOpacity(0.1),
    thickness: 1,
    space: 24,
  ),


);
