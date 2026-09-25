import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1 =
      GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 =
      GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle title =
      GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
   static TextStyle title1 =
      GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  

  static TextStyle body =
      GoogleFonts.inter(
    fontSize: 15,
    color: AppColors.textSecondary,
  );

  static TextStyle caption =
      GoogleFonts.inter(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  

  static TextStyle button =
      GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
}