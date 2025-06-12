import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/auth/invitation_screen.dart';
import '../../presentation/screens/auth/auth_screen.dart';
import '../../presentation/screens/auth/registration_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../constants/app_constants.dart';
import '../di/injection_container.dart';
import '../../presentation/bloc/registration/registration_bloc.dart';

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

      // --- INICIO DE LA CORRECCIÓN ---
      case AppConstants.registerRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider( // 1. Se envuelve la pantalla con BlocProvider
            create: (context) => sl<RegistrationBloc>(), // 2. Se crea la instancia del BLoC
            child: RegistrationScreen( // 3. La pantalla original ahora es el hijo
              invitationCode: args?['invitationCode'] ?? '',
            ),
          ),
        );
      // --- FIN DE LA CORRECCIÓN ---

      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

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