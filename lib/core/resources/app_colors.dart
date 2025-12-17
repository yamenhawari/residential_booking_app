import 'package:flutter/material.dart';

class AppColors {
  // Main Brand Colors
  static const Color primary = Color(0xFF3A57E8); // Solid Royal Blue
  static const Color primaryLight =
      Color(0xFFE8F1FF); // Very light blue for backgrounds

  // Accent Colors (for contrast)
  static const Color secondary = Color(0xFFFF7043); // Soft Coral/Orange
  static const Color secondaryLight = Color(0xFFFFCCBC);

  // Neutrals
  static const Color background = Color(0xFFF9FAFB); // Very light grey/white
  static const Color surface = Colors.white; // Pure white for cards/inputs
  static const Color error = Color(0xFFE53935);

  // Text Colors
  static const Color textPrimary =
      Color(0xFF2D3142); // Dark Blue-Grey (Better than pure black)
  static const Color textSecondary = Color(0xFF9098B1); // Light Grey Text
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color borderDefault = Color(0xFFE0E0E0); // Light Grey Border
  static const Color borderFocus = Color(0xFF3A57E8); // Blue Border
  // Gradient (Smoother transition)
  static const Color gradientStart = Color(0xFF3A57E8);
  static const Color gradientMid = Color(0xFF5E35B1);
  static const Color gradientEnd = Color(0xFF8E24AA);

  // Additional Colors
  static const Color backgroundStart = Color(0xFFE1F5FE);
  static const Color backgroundEnd = Color(0xFFF3E5F5);
  static const Color border = Color(0xFFCE93D8);
  static const Color hint = Color(0xFFBA68C8);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      gradientStart,
      gradientMid,
      gradientEnd,
    ],
  );
}
