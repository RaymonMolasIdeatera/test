import 'package:dartz/dartz.dart';
import 'package:prueba/core/error/failures.dart';
import 'package:prueba/domain/entities/auth_session.dart';
import 'package:prueba/domain/repositories/auth_repository.dart';
import 'package:prueba/domain/usecases/usecase.dart';

class RegisterUser implements UseCase<AuthSession, RegisterUserParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, AuthSession>> call(RegisterUserParams params) async {
    // --- INICIO DE LA CORRECCIÓN ---
    // Se elimina el bloque try-catch. Ahora simplemente llamamos al repositorio
    // y dejamos que su resultado (sea éxito o Failure) fluya hacia el BLoC.
    return await repository.registerWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
      phone: params.phone,
      invitationCode: params.invitationCode,
      metadata: params.metadata,
    );
    // --- FIN DE LA CORRECCIÓN ---
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

// El resto de las clases en este archivo no necesitan cambios.
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