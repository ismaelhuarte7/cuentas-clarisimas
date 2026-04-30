import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background Colors
  static const Color backgroundPrimary = Color(0xFF0D0D0F);    // Obsidian
  static const Color backgroundSecondary = Color(0xFF1A1A1F);  // Charcoal
  static const Color backgroundTertiary = Color(0xFF252530);    // Slate

  // Accent Colors
  static const Color accentPrimary = Color(0xFFD4AF37);        // Champagne Gold
  static const Color accentPrimaryLight = Color(0xFFF5D67A);    // Gold gradient end
  static const Color accentSecondary = Color(0xFFB76E79);      // Rose Gold

  // Semantic Colors
  static const Color success = Color(0xFF2ECC71);              // Emerald
  static const Color error = Color(0xFFE74C3C);                // Red for negative balance
  static const Color warning = Color(0xFFF39C12);               // Warning

  // Text Colors
  static const Color textPrimary = Color(0xFFF5F5F7);           // Pearl
  static const Color textSecondary = Color(0xFFA0A0A8);         // Silver
  static const Color textMuted = Color(0xFF606068);            // Graphite

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPrimary, accentPrimaryLight],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundSecondary, backgroundTertiary],
  );

  static const LinearGradient sheetGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundSecondary, backgroundPrimary],
  );

  // Border Colors
  static Color get borderSubtle => Colors.white.withOpacity(0.08);
  static Color get borderAccent => accentPrimary.withOpacity(0.2);
  static Color get borderFocus => accentPrimary;

  // Shadow
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get fabShadow => [
    BoxShadow(
      color: accentPrimary.withOpacity(0.4),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}