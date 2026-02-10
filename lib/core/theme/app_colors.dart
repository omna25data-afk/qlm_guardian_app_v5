import 'package:flutter/material.dart';

/// App color palette - Arabic-inspired professional design
class AppColors {
  AppColors._();

  // Primary - Deep Gold (رسمي)
  static const Color primary = Color(0xFF1A365D);
  static const Color primaryLight = Color(0xFF2D5A87);
  static const Color primaryDark = Color(0xFF0D1B2A);

  // Accent - Gold
  static const Color accent = Color(0xFFD4AF37);
  static const Color accentLight = Color(0xFFE8C652);
  static const Color accentDark = Color(0xFFB8972E);

  // Background
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Status-specific (for registry entries)
  static const Color draft = Color(0xFF9CA3AF);
  static const Color registeredGuardian = Color(0xFF3B82F6);
  static const Color pendingDocumentation = Color(0xFFF59E0B);
  static const Color documented = Color(0xFF10B981);
  static const Color rejected = Color(0xFFEF4444);

  // Stats & Dashboard
  static const Color statBlue = Color(0xFF3B82F6);
  static const Color statGreen = Color(0xFF10B981);
  static const Color statRed = Color(0xFFEF4444);
  static const Color statAmber = Color(0xFFF59E0B);
  static const Color statTeal = Color(0xFF14B8A6);
  static const Color statIndigo = Color(0xFF6366F1);
  static const Color statOrange = Colors.orange;

  // Borders
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocus = Color(0xFF1A365D);

  // Shadows
  static const Color shadow = Color(0x1A000000);
}
