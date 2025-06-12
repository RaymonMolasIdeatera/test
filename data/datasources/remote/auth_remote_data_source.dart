import 'package:prueba/core/constants/api_constants.dart';
import 'package:prueba/core/utils/logger.dart';
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
  
  // Nuevo método para login
  Future<AuthSession> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
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
      final response = await supabaseClient
          .from(ApiConstants.clientsTable)
          .select('id')
          .eq('wallet_address', invitationCode)
          .maybeSingle();

      return response != null;
    } on PostgrestException catch (e) {
      AppLogger.error('Supabase error verifying invitation', error: e);
      throw ServerException('Failed to verify invitation: ${e.message}');
    } catch (e) {
      AppLogger.error('Generic error verifying invitation', error: e);
      throw ServerException('An unexpected error occurred.');
    }
  }

  @override
  Future<AuthSession> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final session = response.session;
      final user = response.user;

      if (session == null || user == null) {
        throw AuthenticationException('Invalid email or password.');
      }
      
      return AuthSessionModel.fromSupabaseSession(session);
    } on AuthException catch (e) {
      throw AuthenticationException(e.message);
    } catch (e) {
      throw ServerException('An unexpected error occurred during login.');
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
      final response = await supabaseClient.auth.verifyOTP(
        phone: phone,
        token: code,
        type: OtpType.sms,
      );

      if (response.user == null) {
        throw ServerException('Invalid verification code');
      }

      final walletResponse = await supabaseClient.rpc(
        'generate_unique_wallet_address',
      );

      if (walletResponse == null) {
        throw ServerException(
          'Failed to generate wallet address',
        );
      }

      final walletAddress = walletResponse as String;

      await supabaseClient.rpc(
        'register_new_user',
        params: {
          'user_id': response.user!.id,
          'p_wallet_address': walletAddress,
          'p_email': null,
          'p_name': name,
          'p_phone': phone,
          'p_inviter_wallet_address': invitationCode,
          'p_metadata': metadata ?? {},
        },
      );

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
      final oAuthProvider = OAuthProvider.values.firstWhere(
          (p) => p.name.toLowerCase() == provider.toLowerCase());

      final response = await supabaseClient.auth.signInWithOAuth(
        oAuthProvider,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );

      if (!response) {
        throw ServerException('OAuth sign in failed to start.');
      }

      int attempts = 0;
      const maxAttempts = 10;
      while (attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 500));
        final session = supabaseClient.auth.currentSession;
        if (session != null) {
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
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'phone': phone, ...?metadata},
      );

      if (response.user == null) {
        throw ServerException('User registration failed');
      }

      final walletResponse = await supabaseClient.rpc(
        'generate_unique_wallet_address',
      );

      if (walletResponse == null) {
        throw ServerException(
          'Failed to generate wallet address',
        );
      }
      final walletAddress = walletResponse as String;

      await supabaseClient.rpc(
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

      final session = response.session;
      if (session == null) {
        throw ServerException(
            'No session created. Please check if email confirmation is required.');
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

      final response = await supabaseClient
          .from(ApiConstants.clientsTable)
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        await _ensureUserExistsInClients(user);
        final newResponse = await supabaseClient
            .from(ApiConstants.clientsTable)
            .select()
            .eq('id', user.id)
            .single();
        return UserModel.fromSupabase(newResponse);
      }

      return UserModel.fromSupabase(response);
    } catch (e) {
      throw ServerException('Failed to get current user: $e');
    }
  }

  Future<void> _ensureUserExistsInClients(User authUser) async {
    try {
      final existing = await supabaseClient
          .from(ApiConstants.clientsTable)
          .select('id')
          .eq('id', authUser.id)
          .maybeSingle();

      if (existing != null) {
        return;
      }

      final walletResponse =
          await supabaseClient.rpc('generate_unique_wallet_address');
      if (walletResponse == null) {
        throw ServerException('Failed to generate wallet address for OAuth user');
      }
      final walletAddress = walletResponse as String;
      final userMetadata = authUser.userMetadata ?? {};
      final name = userMetadata['name'] ??
          userMetadata['full_name'] ??
          authUser.email?.split('@').first ??
          'User';

      await supabaseClient.rpc(
        'register_new_user',
        params: {
          'user_id': authUser.id,
          'p_wallet_address': walletAddress,
          'p_email': authUser.email,
          'p_name': name,
          'p_phone': userMetadata['phone'],
          'p_inviter_wallet_address': null,
          'p_metadata': userMetadata,
        },
      );
    } catch (e) {
      AppLogger.error('Error ensuring user exists in clients', error: e);
    }
  }
}