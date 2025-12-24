import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  // Light Mode Colors
  static Color lightPrimaryColor = Colors.white;
  static Color lightBackgroundColor = const Color(0xFFF5F5F5);
  static Color lightSurfaceColor = Colors.white;
  static Color lightTextColor = const Color(0xFF171F24);
  static Color lightTextSecondaryColor = const Color(0xFF6B7280);
  static Color lightBorderColor = const Color(0xFFD9D9D9);
  static Color lightInputBackgroundColor = Colors.white;

  // Dark Mode Colors
  static Color darkPrimaryColor = const Color(0xFF1A1A1A);
  static Color darkBackgroundColor = const Color(0xFF121212);
  static Color darkSurfaceColor = const Color(0xFF1E1E1E);
  static Color darkTextColor = Colors.white;
  static Color darkTextSecondaryColor = const Color(0xFF9CA3AF);
  static Color darkBorderColor = const Color.fromARGB(255, 14, 34, 66);
  static Color darkInputBackgroundColor = const Color(0xFF2A2A2A);

  // Common Colors (work in both modes)
  static Color secondaryColor = const Color.fromARGB(255, 12, 47, 70);
  static Color secondaryColor2 = const Color.fromARGB(255, 15, 48, 99);
  static Color accentColor = const Color.fromARGB(255, 17, 64, 109);
  static Color errorColor = const Color(0xFFEF4444);
  static Color successColor = const Color(0xFF10B981);

  // Legacy colors (for backward compatibility)
  static Color primaryColor = Colors.white;
  static Color textColor = const Color(0xFF171F24);
  static Color onBoardinginstructionColor = const Color(0xFF001833);
  static Color textPrimaryLightColor = Colors.white;
  static Color textPrimaryColor = const Color(0xFF0c0d0f);

  // Helper methods to get colors based on theme
  static Color getBackgroundColor(bool isDark) {
    return isDark ? darkBackgroundColor : lightBackgroundColor;
  }

  static Color getSurfaceColor(bool isDark) {
    return isDark ? darkSurfaceColor : lightSurfaceColor;
  }

  static Color getTextColor(bool isDark) {
    return isDark ? darkTextColor : lightTextColor;
  }

  static Color getTextSecondaryColor(bool isDark) {
    return isDark ? darkTextSecondaryColor : lightTextSecondaryColor;
  }

  static Color getBorderColor(bool isDark) {
    return isDark ? darkBorderColor : lightBorderColor;
  }

  static Color getInputBackgroundColor(bool isDark) {
    return isDark ? darkInputBackgroundColor : lightInputBackgroundColor;
  }

  //images
  static String onBoarding1 = "assets/images/onboarding_1.png";
  static String onBoarding2 = "assets/images/onboarding_2.png";
  static String onBoarding3 = "assets/images/onboarding_3.png";
  static String onboardingTextFont = GoogleFonts.outfit().fontFamily!;
}
