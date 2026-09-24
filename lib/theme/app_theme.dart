import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color goldPrimary = Color(0xFFC9A961);
  static const Color goldLight = Color(0xFFE5D4A1);
  static const Color goldDark = Color(0xFF9D7E3F);
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color silverLight = Color(0xFFE8E8E8);
  static const Color silverMid = Color(0xFFB8B8B8);
  static const Color silverDark = Color(0xFF6E6E6E);
  static const Color darkBg = Color(0xFF0A0A0A);
  static const Color darkCard = Color(0xFF141414);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkElevated = Color(0xFF282828);
  static const Color textLight = Color(0xFFF5F5F5);
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color accentRose = Color(0xFFE8B4B8);
  static const Color successGreen = Color(0xFF6FCF97);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    primaryColor: AppColors.goldPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.goldPrimary,
      secondary: AppColors.silverMid,
      surface: AppColors.darkSurface,
      background: AppColors.darkBg,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppColors.textLight,
    ),
    textTheme: GoogleFonts.playfairDisplayTextTheme(
      ThemeData.dark().textTheme,
    ).copyWith(
      bodyMedium: GoogleFonts.poppins(
        color: AppColors.textLight,
        fontSize: 14,
      ),
      bodySmall: GoogleFonts.poppins(
        color: AppColors.textMuted,
        fontSize: 12,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.goldPrimary),
      titleTextStyle: GoogleFonts.playfairDisplay(
        color: AppColors.goldPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.goldPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
      prefixIconColor: AppColors.goldPrimary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.silverDark.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.silverDark.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:
        const BorderSide(color: AppColors.goldPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    ),
  );

  static LinearGradient get goldGradient => const LinearGradient(
    colors: [AppColors.goldLight, AppColors.goldPrimary, AppColors.goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get silverGradient => const LinearGradient(
    colors: [
      AppColors.silverLight,
      AppColors.silverMid,
      AppColors.silverDark
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get overlayGradient => LinearGradient(
    colors: [
      Colors.transparent,
      Colors.black.withOpacity(0.4),
      Colors.black.withOpacity(0.9),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient get luxuryGradient => const LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxShadow get goldGlow => BoxShadow(
    color: AppColors.goldPrimary.withOpacity(0.4),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );
}