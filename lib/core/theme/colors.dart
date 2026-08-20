import 'package:flutter/material.dart';

class AppColors {
  // ----- Brand Colors (Primary) -----
  static const Color primary = Color(0xFF1A73E8); // Google Blue
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on primary
  static const Color primaryContainer = Color(0xFFD2E3FC);
  static const Color onPrimaryContainer = Color(0xFF001B3F);

  // ----- Secondary Colors -----
  static const Color secondary = Color(
    0xFF34A853,
  ); // Green (for success/confirm)
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD4EDDA);
  static const Color onSecondaryContainer = Color(0xFF003D1A);

  // ----- Error Colors -----
  static const Color error = Color(0xFFEA4335); // Red
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFCE8E6);
  static const Color onErrorContainer = Color(0xFF5C1B18);

  // ----- Surface / Background -----
  static const Color surface = Color(0xFFF8F9FA); // Light gray background
  static const Color onSurface = Color(0xFF202124); // Dark text on surface
  static const Color surfaceVariant = Color(0xFFE8EAED);
  static const Color onSurfaceVariant = Color(0xFF444746);

  // ----- Dark Theme Specific -----
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnSurface = Color(0xFFE8EAED);
  static const Color darkPrimary = Color(0xFF8AB4F8);
  static const Color darkSecondary = Color(0xFF81C995);
  static const Color darkError = Color(0xFFF28B82);
  static const Color darkSurfaceVariant = Color(0xFF303134);

  // ----- Status Chips (Priority/Status) -----
  static const Color statusNew = Color(0xFF1A73E8);
  static const Color statusInProgress = Color(0xFFFFA500);
  static const Color statusResolved = Color(0xFF34A853);
  static const Color statusRejected = Color(0xFFEA4335);

  static const Color priorityLow = Color(0xFF34A853);
  static const Color priorityMedium = Color(0xFFFFA500);
  static const Color priorityHigh = Color(0xFFEA4335);
}
