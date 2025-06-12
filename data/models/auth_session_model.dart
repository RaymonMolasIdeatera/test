// lib/data/models/auth_session_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_session.dart';
import 'user_model.dart';

part 'auth_session_model.g.dart';

@JsonSerializable()
class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
    required super.user,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSessionModelToJson(this);

  factory AuthSessionModel.fromSupabase({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required Map<String, dynamic> userData,
  }) {
    return AuthSessionModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      user: UserModel.fromSupabase(userData),
    );
  }

  // Método alias para compatibilidad con el código existente
  factory AuthSessionModel.fromSupabaseSession(dynamic session) {
    // Assuming session is a Supabase Session object with the following structure
    return AuthSessionModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
      expiresAt: DateTime.fromMillisecondsSinceEpoch(session.expiresAt * 1000),
      user: UserModel.fromSupabase(session.user.toJson()),
    );
  }

  // Método para crear desde cualquier sesión de Supabase
  static AuthSessionModel fromAnySupabaseSession(dynamic session) {
    if (session == null) {
      throw Exception('Session cannot be null');
    }
    
    try {
      return AuthSessionModel.fromSupabaseSession(session);
    } catch (e) {
      // Fallback: try to extract data manually
      return AuthSessionModel(
        accessToken: session.accessToken ?? '',
        refreshToken: session.refreshToken ?? '',
        expiresAt: session.expiresAt != null 
            ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt * 1000)
            : DateTime.now().add(const Duration(hours: 1)),
        user: UserModel.fromSupabase(session.user?.toJson() ?? {}),
      );
    }
  }
}