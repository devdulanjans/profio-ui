import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text.dart';

class AppTheme {
  // 🌞 Light Theme (White + Dark Green)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryDarkGreen,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      headlineLarge: AppText.headlineLarge,
      headlineMedium: AppText.headlineMedium,
      bodyLarge: AppText.bodyLarge,
      bodyMedium: AppText.bodyMedium,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.primaryDarkGreen,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonLight,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: AppText.button,
      ),
    ),
  );

  // 🌚 Dark Theme (Black + Green accents)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryDarkGreen,
      brightness: Brightness.dark,
    ),
    textTheme: TextTheme(
      headlineLarge: AppText.headlineLarge.copyWith(color: AppColors.textDark),
      headlineMedium: AppText.headlineMedium.copyWith(color: AppColors.textDark),
      bodyLarge: AppText.bodyLarge.copyWith(color: AppColors.textDark),
      bodyMedium: AppText.bodyMedium.copyWith(color: AppColors.textDark),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.black,
      foregroundColor: AppColors.primaryGreen,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonDark,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: AppText.button,
      ),
    ),
  );
}
