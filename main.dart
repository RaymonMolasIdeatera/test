// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/di/injection_container.dart' as di;
import 'core/constants/api_constants.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize environment variables
    await dotenv.load(fileName: ".env");
    AppLogger.info('Environment variables loaded');
    print('🔧 Supabase URL: ${dotenv.env['SUPABASE_URL']}');

    // Initialize Hive for local storage
    await Hive.initFlutter();
    AppLogger.info('Hive initialized');

    // Initialize Supabase
    await Supabase.initialize(
      url: ApiConstants.supabaseUrl,
      anonKey: ApiConstants.supabaseAnonKey,
      debug: ApiConstants.isDevelopment,
    );
    AppLogger.info('Supabase initialized successfully');

    // ✅ LISTENER PARA CAMBIOS DE AUTENTICACIÓN
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      print('🔄 Auth state changed: $event');
      
      if (event == AuthChangeEvent.signedIn && session != null) {
        print('✅ User signed in: ${session.user.email}');
        print('   User ID: ${session.user.id}');
        print('   Session expires: ${DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)}');
        
        // Aquí puedes agregar lógica adicional después del signin
        // Por ejemplo, verificar si el usuario está registrado en la tabla clients
      } else if (event == AuthChangeEvent.signedOut) {
        print('👋 User signed out');
      } else if (event == AuthChangeEvent.tokenRefreshed) {
        print('🔄 Token refreshed');
      }
    });

    // Initialize dependency injection
    await di.init();
    AppLogger.info('Dependency injection initialized');

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF000000),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    AppLogger.info('CryptoBank app initialized successfully');
    print('🎉 CryptoBank ready to launch!');

    runApp(const CryptoBankApp());
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to initialize app',
      error: e,
      stackTrace: stackTrace,
    );
    print('❌ App initialization failed: $e');
    runApp(ErrorApp(error: e.toString()));
  }
}

// Error App for initialization failures
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoBank - Error',
      home: Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF14b8a6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Failed to start CryptoBank',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a1a),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF14b8a6).withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF9ca3af),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Restart the app
                    main();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14b8a6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}