import 'package:dartz/dartz.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/affiliate_network.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/remote/user_remote_data_source.dart';
import '../datasources/local/user_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.getUserProfile();
        await localDataSource.cacheUserProfile(user);
        return Right(user);
      } else {
        final cachedUser = await localDataSource.getCachedUserProfile();
        if (cachedUser != null) {
          return Right(cachedUser);
        } else {
          return const Left(
            NetworkFailure('No internet connection and no cached data'),
          );
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unknown error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile({
    String? name,
    String? username,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final user = await remoteDataSource.updateUserProfile(
        name: name,
        username: username,
        phone: phone,
        avatarUrl: avatarUrl,
      );

      await localDataSource.cacheUserProfile(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update profile: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> getUserBalance() async {
    try {
      if (await networkInfo.isConnected) {
        final balance = await remoteDataSource.getUserBalance();
        await localDataSource.cacheBalance(balance);
        return Right(balance);
      } else {
        final cachedBalance = await localDataSource.getCachedBalance();
        if (cachedBalance != null) {
          return Right(cachedBalance);
        } else {
          return const Left(
            NetworkFailure('No internet connection and no cached balance'),
          );
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get balance: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getRecentTransactions() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final transactions = await remoteDataSource.getRecentTransactions();
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get transactions: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AffiliateNetwork>>> getAffiliateNetwork() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final network = await remoteDataSource.getAffiliateNetwork();
      return Right(network);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get affiliate network: $e'));
    }
  }
}
