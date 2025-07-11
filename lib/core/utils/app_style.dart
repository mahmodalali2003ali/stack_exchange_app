import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color_app.dart';

abstract class AppStyle {
  static TextStyle styleRegular16(BuildContext context) {
    return GoogleFonts.tajawal(
      color: AppColors.textPrimary,
      fontSize: getResponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleRegular14(BuildContext context) {
    return GoogleFonts.tajawal(
      color: AppColors.textSecondary,
      fontSize: getResponsiveFontSize(context, fontSize: 14),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleRegular12(BuildContext context) {
    return GoogleFonts.tajawal(
      color: AppColors.textSecondary,
      fontSize: getResponsiveFontSize(context, fontSize: 12),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleMedium16(BuildContext context) {
    return GoogleFonts.tajawal(
      color: AppColors.textPrimary,
      fontSize: getResponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleMedium20(BuildContext context) {
    return GoogleFonts.tajawal(
      color: Colors.white,
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleSemiBold18(BuildContext context) {
    return GoogleFonts.tajawal(
      color: Colors.white,
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle styleSemiBold20(BuildContext context) {
    return GoogleFonts.tajawal(
      color: AppColors.textPrimary,
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle styleSemiBold16(BuildContext context) {
    return GoogleFonts.tajawal(
      color: AppColors.textPrimary,
      fontSize: getResponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle styleSemiBold24(BuildContext context) {
    return GoogleFonts.tajawal(
      color: Colors.white,
      fontSize: getResponsiveFontSize(context, fontSize: 24),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle styleBold16(BuildContext context) {
    return GoogleFonts.tajawal(
      color: AppColors.textPrimary,
      fontSize: getResponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w700,
    );
  }

  static double getResponsiveFontSize(BuildContext context, {required double fontSize}) {
    double scaleFactor = getScaleFactor(context);
    double responsiveFontSize = fontSize * scaleFactor;
    double minFontSize = fontSize * 0.8; 
    double maxFontSize = fontSize * 1.2; 
    return responsiveFontSize.clamp(minFontSize, maxFontSize);
  }

  static double getScaleFactor(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 600) {
      return screenWidth / 550;
    } else if (screenWidth < 900) {
      return screenWidth / 1000;
    } else {
      return screenWidth / 1900;
    }
  }
}