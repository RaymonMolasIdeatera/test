import 'package:dartz/dartz.dart';
import '../../entities/affiliate_network.dart';
import '../../repositories/user_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

class GetAffiliateNetwork implements UseCase<List<AffiliateNetwork>, NoParams> {
  final UserRepository repository;

  GetAffiliateNetwork(this.repository);

  @override
  Future<Either<Failure, List<AffiliateNetwork>>> call(NoParams params) async {
    return await repository.getAffiliateNetwork();
  }
}
