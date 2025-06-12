import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../entities/transaction.dart';
import '../entities/affiliate_network.dart';
import '../../core/error/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, User>> updateUserProfile({
    String? name,
    String? username,
    String? phone,
    String? avatarUrl,
  });
  Future<Either<Failure, double>> getUserBalance();
  Future<Either<Failure, List<Transaction>>> getRecentTransactions();
  Future<Either<Failure, List<AffiliateNetwork>>> getAffiliateNetwork();
}
