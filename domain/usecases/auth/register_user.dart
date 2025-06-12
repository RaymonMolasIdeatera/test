import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/auth_session.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class RegisterUser implements UseCase<AuthSession, RegisterUserParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, AuthSession>> call(RegisterUserParams params) async {
    try {
      return await repository.registerWithEmailAndPassword(
        email: params.email,
        password: params.password,
        name: params.name,
        phone: params.phone,
        invitationCode: params.invitationCode,
        metadata: params.metadata,
      );
    } catch (e) {
      // CORRECCIÓN LÍNEA 24: Remover 'message:' y usar solo el string
      return Left(ServerFailure(e.toString()));
    }
  }
}

class RegisterUserParams {
  final String email;
  final String password;
  final String name;
  final String? phone;
  final String? invitationCode;
  final Map<String, dynamic>? metadata;

  RegisterUserParams({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
    this.invitationCode,
    this.metadata,
  });
}

// Nuevo use case para registro con teléfono
class RegisterWithPhone implements UseCase<void, RegisterWithPhoneParams> {
  final AuthRepository repository;

  RegisterWithPhone(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterWithPhoneParams params) async {
    try {
      await repository.registerWithPhone(
        phone: params.phone,
        name: params.name,
        invitationCode: params.invitationCode,
        metadata: params.metadata,
      );
      return const Right(null);
    } catch (e) {
      // CORRECCIÓN LÍNEA 64: Remover 'message:' y usar solo el string
      return Left(ServerFailure(e.toString()));
    }
  }
}

class RegisterWithPhoneParams {
  final String phone;
  final String name;
  final String? invitationCode;
  final Map<String, dynamic>? metadata;

  RegisterWithPhoneParams({
    required this.phone,
    required this.name,
    this.invitationCode,
    this.metadata,
  });
}

// Use case para verificar código de teléfono
class VerifyPhoneAndRegister
    implements UseCase<AuthSession, VerifyPhoneParams> {
  final AuthRepository repository;

  VerifyPhoneAndRegister(this.repository);

  @override
  Future<Either<Failure, AuthSession>> call(VerifyPhoneParams params) async {
    try {
      return await repository.verifyPhoneAndRegister(
        phone: params.phone,
        code: params.code,
        name: params.name,
        invitationCode: params.invitationCode,
        metadata: params.metadata,
      );
    } catch (e) {
      // CORRECCIÓN LÍNEA 101: Remover 'message:' y usar solo el string
      return Left(ServerFailure(e.toString()));
    }
  }
}

class VerifyPhoneParams {
  final String phone;
  final String code;
  final String name;
  final String? invitationCode;
  final Map<String, dynamic>? metadata;

  VerifyPhoneParams({
    required this.phone,
    required this.code,
    required this.name,
    this.invitationCode,
    this.metadata,
  });
}