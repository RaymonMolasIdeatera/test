import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/entities/user.dart' as domain;
import '../../models/auth_session_model.dart';
import '../../models/user_model.dart';
import '../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSession> signInWithBiometric();
  Future<AuthSession> signInWithOAuth(String provider);
  Future<AuthSession> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  });
  Future<void> registerWithPhone({
    required String phone,
    required String name,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  });
  Future<AuthSession> verifyPhoneAndRegister({
    required String phone,
    required String code,
    required String name,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  });
  Future<void> signOut();
  Future<AuthSession?> getCurrentSession();
  Future<domain.User?> getCurrentUser();
  Future<bool> verifyInvitation(String invitationCode);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> registerWithPhone({
    required String phone,
    required String name,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await supabaseClient.auth.signInWithOtp(
        phone: phone,
        data: {'name': name, 'invitation_code': invitationCode, ...?metadata},
      );
    } catch (e) {
      throw ServerException('Failed to send SMS code: $e');
    }
  }
  @override
  Future<bool> verifyInvitation(String invitationCode) async {
    try {
      // Verificar si el código de invitación existe y es válido
      final response = await supabaseClient
          .from('clients')
          .select('id')
          .eq('wallet_address', '0x1234567890123456789012345678901234567890')
          .maybeSingle();
          print('Respuesta Supabase: $response');
      print('Código a verificar: "$invitationCode"');
      return response == null;
    } catch (e) {
      throw ServerException('Failed to verify invitation: $e');
    }
  }
  @override
  Future<AuthSession> verifyPhoneAndRegister({
    required String phone,
    required String code,
    required String name,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // 1. Verificar código SMS
      final response = await supabaseClient.auth.verifyOTP(
        phone: phone,
        token: code,
        type: OtpType.sms,
      );

      if (response.user == null) {
        throw ServerException('Invalid verification code');
      }

      // 2. Generar wallet address único
      final walletResponse = await supabaseClient.rpc(
        'generate_unique_wallet_address',
      );

      if (walletResponse == null) {
        throw ServerException(
          'Failed to generate wallet address',
        );
      }

      final walletAddress = walletResponse as String;

      // 3. Crear usuario en tabla clients
      await supabaseClient.rpc(
        'register_new_user',
        params: {
          'user_id': response.user!.id,
          'p_wallet_address': walletAddress,
          'p_email': null, // No email for phone registration
          'p_name': name,
          'p_phone': phone,
          'p_inviter_wallet_address': invitationCode,
          'p_metadata': metadata ?? {},
        },
      );

      // 4. Retornar sesión
      final session = response.session;
      if (session == null) {
        throw ServerException('No session created');
      }

      return AuthSessionModel.fromSupabaseSession(session);
    } catch (e) {
      throw ServerException('Phone verification failed: $e');
    }
  }

  @override
  Future<AuthSession> signInWithBiometric() async {
    try {
      // Para el MVP, usamos el último usuario logueado
      final session = supabaseClient.auth.currentSession;
      if (session != null) {
        return AuthSessionModel.fromSupabaseSession(session);
      }
      throw ServerException('No biometric session found');
    } catch (e) {
      throw ServerException('Biometric login failed: $e');
    }
  }

  @override
  Future<AuthSession> signInWithOAuth(String provider) async {
    try {
      final response = await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.values.firstWhere(
          (p) => p.name.toLowerCase() == provider.toLowerCase(),
        ),
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );

      if (!response) {
        throw ServerException('OAuth sign in failed');
      }

      // Esperar a que la sesión se establezca
      int attempts = 0;
      const maxAttempts = 10;

      while (attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 500));
        final session = supabaseClient.auth.currentSession;

        if (session != null) {
          // NUEVO: Verificar si el usuario existe en clients, si no, crearlo
          await _ensureUserExistsInClients(session.user);
          return AuthSessionModel.fromSupabaseSession(session);
        }
        attempts++;
      }

      throw ServerException('OAuth session not established');
    } catch (e) {
      throw ServerException('OAuth sign in failed: $e');
    }
  }

  @override
  Future<AuthSession> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // 1. Registrar en Supabase Auth
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'phone': phone, ...?metadata},
      );

      if (response.user == null) {
        throw ServerException('User registration failed');
      }

      // 2. Generar wallet address único
      final walletResponse = await supabaseClient.rpc(
        'generate_unique_wallet_address',
      );

      if (walletResponse == null) {
        throw ServerException(
          'Failed to generate wallet address',
        );
      }

      final walletAddress = walletResponse as String;

      // 3. Crear usuario en tabla clients usando la función register_new_user
      final registerResponse = await supabaseClient.rpc(
        'register_new_user',
        params: {
          'user_id': response.user!.id,
          'p_wallet_address': walletAddress,
          'p_email': email,
          'p_name': name,
          'p_phone': phone,
          'p_inviter_wallet_address': invitationCode,
          'p_metadata': metadata ?? {},
        },
      );

      if (registerResponse == null) {
        throw ServerException('Failed to create user profile');
      }

      // 4. Retornar sesión
      final session = response.session;
      if (session == null) {
        throw ServerException('No session created');
      }

      return AuthSessionModel.fromSupabaseSession(session);
    } catch (e) {
      throw ServerException('Registration failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException('Sign out failed: $e');
    }
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session != null) {
        return AuthSessionModel.fromSupabaseSession(session);
      }
      return null;
    } catch (e) {
      throw ServerException('Failed to get current session: $e');
    }
  }

  @override
  Future<domain.User?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return null;

      // Obtener datos del usuario desde la tabla clients
      final response =
          await supabaseClient
              .from('clients')
              .select()
              .eq('id', user.id)
              .maybeSingle();

      if (response == null) {
        // Si no existe en clients, crearlo automáticamente
        await _ensureUserExistsInClients(user);

        // Intentar obtener nuevamente
        final newResponse =
            await supabaseClient
                .from('clients')
                .select()
                .eq('id', user.id)
                .single();

        return UserModel.fromJson(newResponse);
      }

      return UserModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get current user: $e');
    }
  }

  // NUEVA FUNCIÓN: Asegurar que el usuario existe en la tabla clients
  Future<void> _ensureUserExistsInClients(User authUser) async {
    try {
      // Verificar si ya existe
      final existing =
          await supabaseClient
              .from('clients')
              .select('id')
              .eq('id', authUser.id)
              .maybeSingle();

      if (existing != null) {
        // Ya existe, no hacer nada
        return;
      }

      // No existe, crear registro
      final walletResponse = await supabaseClient.rpc(
        'generate_unique_wallet_address',
      );

      if (walletResponse == null) {
        throw ServerException(
          'Failed to generate wallet address',
        );
      }

      final walletAddress = walletResponse as String;

      // Extraer datos del usuario de auth
      final userMetadata = authUser.userMetadata ?? {};
      final name =
          userMetadata['name'] ??
          userMetadata['full_name'] ??
          authUser.email?.split('@').first ??
          'User';

      // Crear usando la función register_new_user
      await supabaseClient.rpc(
        'register_new_user',
        params: {
          'user_id': authUser.id,
          'p_wallet_address': walletAddress,
          'p_email': authUser.email,
          'p_name': name,
          'p_phone': userMetadata['phone'],
          'p_inviter_wallet_address':
              null, // No hay código de invitación para OAuth
          'p_metadata': userMetadata,
        },
      );
    } catch (e) {
      print('Error ensuring user exists in clients: $e');
      // No lanzar excepción aquí para no interrumpir el flujo de login
    }
  }
}
