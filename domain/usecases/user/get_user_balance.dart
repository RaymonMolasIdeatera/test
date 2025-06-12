import 'package:dartz/dartz.dart';
import '../../repositories/user_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

class GetUserBalance implements UseCase<double, NoParams> {
  final UserRepository repository;

  GetUserBalance(this.repository);

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    return await repository.getUserBalance();
  }
}
