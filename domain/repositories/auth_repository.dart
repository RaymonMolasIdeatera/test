import 'package:dartz/dartz.dart';
import 'package:prueba/core/error/failures.dart';
import 'package:prueba/domain/entities/auth_session.dart';
import 'package:prueba/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> loginWithBiometric();
  Future<Either<Failure, AuthSession>> loginWithOAuth(String provider);
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
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthSession?>> checkAuthStatus();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> verifyInvitation(String invitationCode);

  // --- MÉTODO NUEVO AÑADIDO ---
  Future<Either<Failure, AuthSession>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}