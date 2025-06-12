import 'package:flutter/material.dart';

import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/auth/invitation_screen.dart';
import '../../presentation/screens/auth/auth_screen.dart';
import '../../presentation/screens/auth/registration_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
//import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../constants/app_constants.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppConstants.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case AppConstants.invitationRoute:
        return MaterialPageRoute(builder: (_) => const InvitationScreen());

      case AppConstants.authRoute:
        return MaterialPageRoute(builder: (_) => const AuthScreen());

      case AppConstants.registerRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => RegistrationScreen(
                invitationCode: args?['invitationCode'] ?? '',
              ),
        );

      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      //case AppConstants.profileRoute:
      // return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppConstants.settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
