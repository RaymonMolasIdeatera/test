import 'package:dartz/dartz.dart';
import '../../entities/auth_session.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

class LoginWithBiometric implements UseCase<AuthSession, NoParams> {
  final AuthRepository repository;

  LoginWithBiometric(this.repository);

  @override
  Future<Either<Failure, AuthSession>> call(NoParams params) async {
    return await repository.loginWithBiometric();
  }
}
