import 'package:flutter/material.dart';

class AppColors {
  /// 🔵 اللون الأساسي للتطبيق (يشتغل مع لايت ودارك)
  static const Color primary = Color(0xFF6EA1EA);

  // =======================
  // 🌞 Light Mode Colors
  // =======================

  /// خلفية الصفحات
  static const Color background = Color(0xFFFFFFFF);

  /// النصوص الأساسية
  static const Color textPrimary = Color(0xFF212121);

  /// نص فوق اللون الأساسي (أزرار)
  static const Color textOnPrimary = Colors.white;

  /// ظل خفيف للكروت
  static const Color shadow = Color(0x1A000000);

  /// خلفية حقول الإدخال
  static const Color inputFill = Color(0xFFF3F4F6);

  /// Divider
  static const Color divider = Color(0xFFE0E0E0);

  /// نص ثانوي
  static const Color textSecondary = Color(0xFF9E9E9E);

  // =======================
  // 🌙 Dark Mode Colors
  // =======================

  /// خلفية الصفحات (دارك)
  static const Color darkBackground = Color(0xFF121212);

  /// خلفية الكروت و TextField
  static const Color darkSurface = Color(0xFF1E1E1E);

  /// النص الأساسي (دارك)
  static const Color darkTextPrimary = Color(0xFFE0E0E0);

  /// النص الثانوي (دارك)
  static const Color darkTextSecondary = Color(0xFF9E9E9E);

  /// Divider (دارك)
  static const Color darkDivider = Color(0xFF2C2C2C);

  /// ظل خفيف (دارك)
  static const Color darkShadow = Color(0x33000000);
}