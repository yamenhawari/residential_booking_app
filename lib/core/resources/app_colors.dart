import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3A57E8);
  static const Color primaryLight = Color(0xFFE8F1FF);

  static const Color secondary = Color(0xFFFF7043);
  static const Color secondaryLight = Color(0xFFFFCCBC);

  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);

  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF2D3142);
  static const Color textSecondaryLight = Color(0xFF9098B1);
  static const Color borderLight = Color(0xFFE0E0E0);

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color borderDark = Color(0xFF333333);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3A57E8),
      Color(0xFF5E35B1),
      Color(0xFF8E24AA),
    ],
  );
}
