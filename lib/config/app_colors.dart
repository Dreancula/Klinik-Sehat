import 'package:flutter/material.dart';

class AppColors {
  // Pastel Backgrounds
  static const Color pastelMint = Color(0xFFCFEBDF);
  static const Color pastelGreen = Color(0xFFE2FADB);
  static const Color backgroundLight = Color(0xFFF7FCF9);

  // Typography
  static const Color primaryText = Color(0xFF2C3E50); // Dark Slate / Abu-abu Tua
  static const Color secondaryText = Color(0xFF7F8C8D); // Medium Grey / Abu-abu Sedang

  // Brand Accents & Actions
  static const Color accentGreen = Color(0xFF27AE60); // Hijau Tua / Emerald
  static const Color accentGreenLight = Color(0xFF2ECC71);
  static const Color danger = Color(0xFFE74C3C); // Merah untuk Hapus
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF2980B9);

  // Surface & Borders
  static const Color cardSurface = Colors.white;
  static const Color borderSubtle = Color(0xFFD6E9DF);

  // Gradient
  static const LinearGradient mainGradient = LinearGradient(
    colors: [pastelMint, pastelGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardHeaderGradient = LinearGradient(
    colors: [Color(0xFFE8F8F0), Color(0xFFF2FDF0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentGreen, Color(0xFF2ECC71)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
