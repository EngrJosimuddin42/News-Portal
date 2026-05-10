import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get display => GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.surface,
  );

  static TextStyle get displayMedium => GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
    height: 1.15,
  );

  static TextStyle get medium => GoogleFonts.inter(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    height: 1.15,
  );

  static TextStyle get displaySmall => GoogleFonts.inter(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
    height: 1.2,
  );

  static TextStyle get small => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
  );

  static TextStyle get large => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.surface,
  );

  static TextStyle get textSmall => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.overlay,
    height: 1.2,
  );

  // Headline - DM Sans (clean, modern)
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.linkColor,
    height: 1.3,
  );

  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
    height: 1.3,
  );

  static TextStyle get headlineSmall => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.surface,
    height: 1.4,
  );

  // Body
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary1,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.background,
    height: 1.4,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.surface,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );

  // Button
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.surface,
    letterSpacing: 0.2,
  );

  static TextStyle get buttonOutline => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.surface,
    letterSpacing: 0.2,
  );

  // Caption / Overline
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.surface,
    letterSpacing: 0.4,
  );

  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    letterSpacing: 1.5,
  );

  static TextStyle get chart => GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.background,
    height: 1.0,
  );

  static TextStyle get success => GoogleFonts.inter(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
    height: 1.0,
  );

  static TextStyle get head => GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    height: 1.0,
  );

  static TextStyle get label => GoogleFonts.inter(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    height: 1.0,
  );

  static TextStyle get tagline => GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
  );

  static TextStyle get title => GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.background,
  );

  static TextStyle get heading => GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
  );
}