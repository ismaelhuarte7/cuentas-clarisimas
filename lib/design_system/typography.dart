import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  AppTypography._();

  // Display - Hero numbers
  static TextStyle get display => GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppColors.textPrimary,
    letterSpacing: -1,
  );

  // Heading 1
  static TextStyle get heading1 => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  // Heading 2
  static TextStyle get heading2 => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // Body Large
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // Body
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // Caption
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // Button
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  // Button Small
  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  // Amount Display (for money values)
  static TextStyle get amount => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  // Amount Small
  static TextStyle get amountSmall => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textPrimary,
  );
}