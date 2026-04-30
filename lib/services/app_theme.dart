import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system/colors.dart';
import '../design_system/typography.dart';
import '../providers/theme_provider.dart';

class AppTheme {
  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.old:
        return _buildThemeOld();
      case AppThemeMode.promiedos:
        return _buildThemePromiedos();
    }
  }

  static ThemeData _buildThemeOld() {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF39C12),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFD35400),
        secondary: Color(0xFFF39C12),
        surface: Color(0xFFFFEAA7),
        error: Colors.red,
      ),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        displayLarge: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        headlineLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
        bodyMedium: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        bodySmall: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF333333),
        elevation: 4,
        centerTitle: false,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD35400),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFF333333), width: 2),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD35400), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Color(0xFFFAE5D3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFF333333), width: 2),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF333333),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData _buildThemePromiedos() {
    const bg = Color(0xFF0e311a);
    const cardBg = Color(0xFF1a1a1a);
    const headerBg = Color(0xFF111111);
    const accentBlue = Color(0xFF007bff);
    const accentYellow = Color(0xFFffc107);
    const border = Color(0xFF333333);
    const textPrimary = Color(0xFFe0e0e0);
    const textSecondary = Color(0xFFa0a0a0);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: accentYellow,
        surface: cardBg,
        error: Colors.red,
      ),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary),
        headlineLarge: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
        headlineMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: const TextStyle(fontSize: 16, color: textPrimary),
        bodyMedium: const TextStyle(fontSize: 14, color: textPrimary),
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
        bodySmall: const TextStyle(fontSize: 12, color: textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: headerBg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: accentBlue)),
        hintStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardBg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

class ThemeColors {
  static const Color oldBackground = Color(0xFFF39C12);
  static const Color oldBackgroundDark = Color(0xFFD35400);
  static const Color oldCard = Color(0xFFFAE5D3);
  static const Color oldAccent = Color(0xFFD35400);
  static const Color oldError = Colors.red;
  static const Color oldSuccess = Colors.green;

  static const Color promiedosBackground = Color(0xFF0e311a);
  static const Color promiedosCard = Color(0xFF1a1a1a);
  static const Color promiedosAccent = Color(0xFF007bff);
  static const Color promiedosError = Color(0xFFe74c3c);
  static const Color promiedosSuccess = Color(0xFF27ae60);

  static Color getBackground(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.old:
        return oldBackground;
      case AppThemeMode.promiedos:
        return promiedosBackground;
    }
  }

  static LinearGradient getBackgroundGradient(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.old:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF39C12), Color(0xFFD35400)],
        );
      case AppThemeMode.promiedos:
        return const LinearGradient(colors: [promiedosBackground, promiedosBackground]);
    }
  }

  static Color getCard(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.old:
        return oldCard;
      case AppThemeMode.promiedos:
        return promiedosCard;
    }
  }

  static Color getAccent(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.old:
        return oldAccent;
      case AppThemeMode.promiedos:
        return promiedosAccent;
    }
  }

  static Color getError(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.old:
        return oldError;
      case AppThemeMode.promiedos:
        return promiedosError;
    }
  }

  static Color getSuccess(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.old:
        return oldSuccess;
      case AppThemeMode.promiedos:
        return promiedosSuccess;
    }
  }

  static BorderRadius getRadius(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.old:
        return BorderRadius.circular(8);
      case AppThemeMode.promiedos:
        return BorderRadius.circular(4);
    }
  }

  static List<BoxShadow>? getShadow(AppThemeMode mode) {
    return null;
  }

  static Color getAppBarBg(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.old:
        return const Color(0xFF333333);
      case AppThemeMode.promiedos:
        return const Color(0xFF111111);
    }
  }
}