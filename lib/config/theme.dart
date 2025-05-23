import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF8C3103);
  static const Color secondaryColor = Color(0xFFFFB300);
  static const Color accentColor = Color(0xFF2E7D32);
  
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  
  static const Color textLight = Color(0xFF212121);
  static const Color textDark = Color(0xFFE0E0E0);
  
  static const Color errorColor = Color(0xFFB71C1C);
  static const Color successColor = Color(0xFF2E7D32);
  static const Color warningColor = Color(0xFFF57F17);
  static const Color infoColor = Color(0xFF0288D1);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFBF360C), Color(0xFF8C3103)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Text styles
  static TextStyle get headingStyle => const TextStyle(
    fontFamily: 'Amiri',
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static TextStyle get bodyStyle => const TextStyle(
    fontFamily: 'Amiri',
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundLight,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: TextTheme(
        displayLarge: headingStyle.copyWith(fontSize: 32, color: textLight),
        displayMedium: headingStyle.copyWith(fontSize: 28, color: textLight),
        displaySmall: headingStyle.copyWith(fontSize: 24, color: textLight),
        headlineMedium: headingStyle.copyWith(fontSize: 20, color: textLight),
        headlineSmall: headingStyle.copyWith(fontSize: 18, color: textLight),
        titleLarge: headingStyle.copyWith(fontSize: 16, color: textLight),
        bodyLarge: bodyStyle.copyWith(fontSize: 16, color: textLight),
        bodyMedium: bodyStyle.copyWith(fontSize: 14, color: textLight),
        bodySmall: bodyStyle.copyWith(fontSize: 12, color: textLight),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        titleTextStyle: headingStyle.copyWith(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFBDBDBD),
        thickness: 1,
        space: 24,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }
  
  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundDark,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundDark,
      textTheme: TextTheme(
        displayLarge: headingStyle.copyWith(fontSize: 32, color: textDark),
        displayMedium: headingStyle.copyWith(fontSize: 28, color: textDark),
        displaySmall: headingStyle.copyWith(fontSize: 24, color: textDark),
        headlineMedium: headingStyle.copyWith(fontSize: 20, color: textDark),
        headlineSmall: headingStyle.copyWith(fontSize: 18, color: textDark),
        titleLarge: headingStyle.copyWith(fontSize: 16, color: textDark),
        bodyLarge: bodyStyle.copyWith(fontSize: 16, color: textDark),
        bodyMedium: bodyStyle.copyWith(fontSize: 14, color: textDark),
        bodySmall: bodyStyle.copyWith(fontSize: 12, color: textDark),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        titleTextStyle: headingStyle.copyWith(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryColor,
          side: const BorderSide(color: secondaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        fillColor: const Color(0xFF1E1E1E),
        filled: true,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF424242),
        thickness: 1,
        space: 24,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: secondaryColor,
        unselectedItemColor: Colors.grey,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: secondaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: secondaryColor, width: 2),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: secondaryColor,
      ),
    );
  }
}