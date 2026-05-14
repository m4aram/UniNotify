import 'package:flutter/material.dart';
import 'color.dart';

class AppTheme {
 static ThemeData themeEnglish = ThemeData(
    fontFamily: 'Roboto',
    brightness: Brightness.light,
  );

  static ThemeData themeArabic = ThemeData(
    fontFamily: 'Cairo',
    brightness: Brightness.light,
  ); 
  
  // =======================
  // 🌞 Light Theme
  // =======================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,

    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      background: AppColors.background,
      surface: AppColors.inputFill,
      onPrimary: AppColors.textOnPrimary,
      onBackground: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
    ),

    // =======================
    // 📝 TextField Theme
    // =======================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.primary, // ⭐ يمنع البنفسجي
        fontWeight: FontWeight.w500,
      ),
      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
      ),
      prefixIconColor: AppColors.primary,
      suffixIconColor: AppColors.primary,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.divider,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),

    // =======================
    // ☑ Checkbox
    // =======================
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? AppColors.primary
            : Colors.transparent,
      ),
      checkColor: MaterialStateProperty.all(
        AppColors.textOnPrimary,
      ),
      side: const BorderSide(
        color: AppColors.divider,
      ),
    ),

    // =======================
    // 🔘 Buttons
    // =======================
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // =======================
    // ✏ Cursor & Selection
    // =======================
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withOpacity(0.3),
      selectionHandleColor: AppColors.primary,
    ),

    // =======================
    // 📱 AppBar
    // =======================
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // =======================
  // 🌙 Dark Theme
  // =======================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      onPrimary: Colors.black,
      onBackground: AppColors.darkTextPrimary,
      onSurface: AppColors.darkTextPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      labelStyle: const TextStyle(
        color: AppColors.darkTextSecondary,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: const TextStyle(
        color: AppColors.darkTextSecondary,
      ),
      prefixIconColor: AppColors.primary,
      suffixIconColor: AppColors.primary,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.darkDivider,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(AppColors.primary),
      checkColor: MaterialStateProperty.all(Colors.black),
      side: const BorderSide(color: AppColors.darkDivider),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withOpacity(0.3),
      selectionHandleColor: AppColors.primary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    
  );
}
