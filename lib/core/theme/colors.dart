import 'package:flutter/material.dart';

/// The palette.
///
/// Built around a deep institutional teal rather than a stock brand blue: it
/// reads as civic and calm, and it leaves blue free to mean "information"
/// inside status chips instead of competing with the brand.
///
/// Neutrals carry a slight teal bias so greys sit with the accent instead of
/// looking like a separate, colder system.
class AppColors {
  AppColors._();

  // ----------------------------- Brand -------------------------------------
  static const Color primary = Color(0xFF0E6E6E);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFD3EDEA);
  static const Color onPrimaryContainer = Color(0xFF042A2A);

  /// Warm counterweight to the teal. Used sparingly: the submit action, an
  /// unread badge, the selected nav item.
  static const Color accent = Color(0xFFC2703A);
  static const Color onAccent = Color(0xFFFFFFFF);
  static const Color accentContainer = Color(0xFFFAE6D8);
  static const Color onAccentContainer = Color(0xFF3D1F0B);

  // ----------------------------- Neutrals ----------------------------------
  // Very slightly teal-biased so they sit with the brand, not beside it.
  static const Color background = Color(0xFFF4F7F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEDF2F2);
  static const Color onSurface = Color(0xFF14201F);
  static const Color onSurfaceVariant = Color(0xFF5A6A69);
  static const Color outline = Color(0xFFD3DEDD);
  static const Color outlineStrong = Color(0xFFB6C6C4);

  // ------------------------------- Dark ------------------------------------
  static const Color darkBackground = Color(0xFF0D1413);
  static const Color darkSurface = Color(0xFF162020);
  static const Color darkSurfaceMuted = Color(0xFF1E2B2A);
  static const Color darkOnSurface = Color(0xFFE3ECEB);
  static const Color darkOnSurfaceVariant = Color(0xFF9DAFAD);
  static const Color darkOutline = Color(0xFF2C3B3A);
  static const Color darkOutlineStrong = Color(0xFF3E5150);

  static const Color darkPrimary = Color(0xFF5CC9C0);
  static const Color onDarkPrimary = Color(0xFF00201E);
  static const Color darkPrimaryContainer = Color(0xFF14403E);
  static const Color onDarkPrimaryContainer = Color(0xFFB9E9E4);

  static const Color darkAccent = Color(0xFFE79A67);
  static const Color onDarkAccent = Color(0xFF2B1405);

  // ---------------------------- Semantic -----------------------------------
  // Separate from the brand accent: these mean state, never decoration.
  static const Color success = Color(0xFF2E7D52);
  static const Color onSuccessContainer = Color(0xFF10331F);
  static const Color successContainer = Color(0xFFD8EDE1);

  static const Color warning = Color(0xFFA96A0B);
  static const Color onWarningContainer = Color(0xFF3A2404);
  static const Color warningContainer = Color(0xFFFBEBD2);

  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);

  static const Color info = Color(0xFF1F6FB2);
  static const Color onInfoContainer = Color(0xFF0B2D49);
  static const Color infoContainer = Color(0xFFD9E8F5);

  // Dark-mode semantic pairs.
  static const Color darkSuccess = Color(0xFF7BCB9E);
  static const Color darkSuccessContainer = Color(0xFF163A28);
  static const Color darkWarning = Color(0xFFE0B063);
  static const Color darkError = Color(0xFFEC9C95);
  static const Color darkInfo = Color(0xFF7FB6E4);

  // ------------------------ Complaint status --------------------------------
  // Mapped onto the semantic ramp so status colour and meaning never drift.
  static const Color statusNew = info;
  static const Color statusInProgress = warning;
  static const Color statusResolved = success;
  static const Color statusRejected = error;

  static const Color priorityLow = success;
  static const Color priorityMedium = warning;
  static const Color priorityHigh = error;
}
