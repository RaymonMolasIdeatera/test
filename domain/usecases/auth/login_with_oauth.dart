import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/auth_session.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

class LoginWithOAuth implements UseCase<AuthSession, OAuthParams> {
  final AuthRepository repository;

  LoginWithOAuth(this.repository);

  @override
  Future<Either<Failure, AuthSession>> call(OAuthParams params) async {
    return await repository.loginWithOAuth(params.provider);
  }
}

class OAuthParams extends Equatable {
  final String provider;

  const OAuthParams({required this.provider});

  @override
  List<Object> get props => [provider];
}
