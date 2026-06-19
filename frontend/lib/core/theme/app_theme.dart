import "package:flutter/material.dart";

class AppTheme {
  static const Color primary = Color(0xFFb9c7e4);
  static const Color onPrimary = Color(0xFF233148);
  static const Color primaryContainer = Color(0xFF0a192f);
  static const Color onPrimaryContainer = Color(0xFF74829d);
  static const Color secondary = Color(0xFFc1ffd5);
  static const Color onSecondary = Color(0xFF00391f);
  static const Color secondaryContainer = Color(0xFF05f297);
  static const Color onSecondaryContainer = Color(0xFF00693f);
  static const Color tertiary = Color(0xFF3cd7ff);
  static const Color onTertiary = Color(0xFF003642);
  static const Color error = Color(0xFFffb4ab);
  static const Color errorContainer = Color(0xFF93000a);
  static const Color onError = Color(0xFF690005);
  static const Color background = Color(0xFF131313);
  static const Color onBackground = Color(0xFFe5e2e1);
  static const Color surface = Color(0xFF131313);
  static const Color onSurface = Color(0xFFe5e2e1);
  static const Color onSurfaceVariant = Color(0xFFc5c6cd);
  static const Color outline = Color(0xFF8f9097);
  static const Color outlineVariant = Color(0xFF44474d);
  static const Color surfaceContainerLowest = Color(0xFF0e0e0e);
  static const Color surfaceContainerLow = Color(0xFF1c1b1b);
  static const Color surfaceContainer = Color(0xFF201f1f);
  static const Color surfaceContainerHigh = Color(0xFF2a2a2a);
  static const Color surfaceContainerHighest = Color(0xFF353534);
  static const Color surfaceBright = Color(0xFF393939);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: "Poppins",
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
        ),
        headlineLarge: TextStyle(
          fontFamily: "Poppins",
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          fontFamily: "Poppins",
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontFamily: "Inter",
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontFamily: "Inter",
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        labelMedium: TextStyle(
          fontFamily: "Inter",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0a0a0a),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: tertiary, width: 1),
        ),
        labelStyle: const TextStyle(color: onSurfaceVariant),
      ),
    );
  }
}
