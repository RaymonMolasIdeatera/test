// lib/core/constants/app_constants.dart
class AppConstants {
  // App Info
  static const String appName = 'CryptoBank';
  static const String appTagline = 'The future is now';
  static const String appVersion = '1.0.0';

  // Network
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String deviceIdKey = 'device_id';
  static const String walletAddressKey = 'wallet_address';

  // Routes
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String invitationRoute = '/invitation';
  static const String authRoute = '/auth';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Initial Balances (MVP)
  static const double welcomeBonus = 100.0;
  static const double referralBonus = 50.0;
}
