import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

class Logout implements UseCase<Unit, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    // CORRECCIÓN: Convertir el Either<Failure, void> a Either<Failure, Unit>
    final result = await repository.logout();
    return result.fold(
      (failure) => Left(failure),
      (_) => const Right(unit), // Convertir void a Unit
    );
  }
}