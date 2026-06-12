import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  /// Tema Terang (Light Mode)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      brightness: Brightness.light,
      textTheme: AppTextStyles.lightTextTheme,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      elevatedButtonTheme: _elevatedButtonTheme,
      cardTheme: _cardTheme,
      inputDecorationTheme: _inputDecorationTheme(isDark: false),
      scaffoldBackgroundColor: AppColors.backgroundLight,
    );
  }

  /// Tema Gelap (Dark Mode)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      brightness: Brightness.dark,
      textTheme: AppTextStyles.darkTextTheme,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
      ),
      elevatedButtonTheme: _elevatedButtonTheme,
      cardTheme: _cardTheme,
      inputDecorationTheme: _inputDecorationTheme(isDark: true),
      scaffoldBackgroundColor: AppColors.backgroundDark,
    );
  }

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
        ),
      );

  static final CardThemeData _cardTheme = CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      side: const BorderSide(color: AppColors.dividerLight, width: 1),
    ),
    clipBehavior: Clip.antiAlias,
  );

  static InputDecorationTheme _inputDecorationTheme({required bool isDark}) {
    final borderColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    // final fillColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return InputDecorationTheme(
      // filled: true,
      // fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.md,
      ),
    );
  }
}
