// lib/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/auth_session.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // Métodos existentes renombrados para consistencia
  Future<Either<Failure, AuthSession>> loginWithBiometric();
  Future<Either<Failure, AuthSession>> loginWithOAuth(String provider);
  Future<Either<Failure, AuthSession>> signInWithBiometric();
  Future<Either<Failure, AuthSession>> signInWithOAuth(String provider);
  
  // Métodos de registro
  Future<Either<Failure, AuthSession>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  });
  
  Future<Either<Failure, void>> registerWithPhone({
    required String phone,
    required String name,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  });
  
  Future<Either<Failure, AuthSession>> verifyPhoneAndRegister({
    required String phone,
    required String code,
    required String name,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  });
  
  // Métodos de sesión
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, AuthSession?>> getCurrentSession();
  Future<Either<Failure, AuthSession?>> checkAuthStatus();
  Future<Either<Failure, User?>> getCurrentUser();
  
  // Método de verificación de invitación
  Future<Either<Failure, bool>> verifyInvitation(String invitationCode);
}