import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:prueba/core/error/failures.dart';
import 'package:prueba/domain/entities/auth_session.dart';
import 'package:prueba/domain/repositories/auth_repository.dart';
import 'package:prueba/domain/usecases/usecase.dart';

class LoginUser implements UseCase<AuthSession, LoginParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, AuthSession>> call(LoginParams params) async {
    return await repository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}