import 'package:dartz/dartz.dart';
import 'package:prueba/core/error/failures.dart';
import 'package:prueba/core/error/exceptions.dart';
import 'package:prueba/core/network/network_info.dart';
import 'package:prueba/data/datasources/remote/auth_remote_data_source.dart';
import 'package:prueba/data/datasources/local/auth_local_data_source.dart';
import 'package:prueba/domain/repositories/auth_repository.dart';
import 'package:prueba/domain/entities/auth_session.dart';
import 'package:prueba/domain/entities/user.dart';
import 'package:prueba/data/models/auth_session_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // CORRECCIÓN: Método para convertir AuthSession a AuthSessionModel
  AuthSessionModel _toAuthSessionModel(AuthSession session) {
    if (session is AuthSessionModel) {
      return session;
    }
    return AuthSessionModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: session.expiresAt,
      user: session.user,
    );
  }

  @override
  Future<Either<Failure, AuthSession>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final session = await remoteDataSource.loginWithEmailAndPassword(
          email: email,
          password: password,
        );
        await localDataSource.cacheSession(_toAuthSessionModel(session));
        return Right(session);
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithBiometric() async {
    if (await networkInfo.isConnected) {
      try {
        final session = await remoteDataSource.signInWithBiometric();
        await localDataSource.cacheSession(_toAuthSessionModel(session));
        return Right(session);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final session = await localDataSource.getCachedSession();
        if (session != null) {
          return Right(session);
        } else {
          return const Left(NetworkFailure('No cached session available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithOAuth(String provider) async {
    if (await networkInfo.isConnected) {
      try {
        final session = await remoteDataSource.signInWithOAuth(provider);
        await localDataSource.cacheSession(_toAuthSessionModel(session));
        return Right(session);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> loginWithBiometric() async {
    return await signInWithBiometric();
  }

  @override
  Future<Either<Failure, AuthSession>> loginWithOAuth(String provider) async {
    return await signInWithOAuth(provider);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return await signOut();
  }

  @override
  Future<Either<Failure, AuthSession?>> checkAuthStatus() async {
    return await getCurrentSession();
  }

  @override
  Future<Either<Failure, bool>> verifyInvitation(String invitationCode) async {
    if (await networkInfo.isConnected) {
      try {
        final isValid = await remoteDataSource.verifyInvitation(invitationCode);
        return Right(isValid);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final session = await remoteDataSource.registerWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
          phone: phone,
          invitationCode: invitationCode,
          metadata: metadata,
        );
        await localDataSource.cacheSession(_toAuthSessionModel(session));
        return Right(session);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> registerWithPhone({
    required String phone,
    required String name,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.registerWithPhone(
          phone: phone,
          name: name,
          invitationCode: invitationCode,
          metadata: metadata,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> verifyPhoneAndRegister({
    required String phone,
    required String code,
    required String name,
    String? invitationCode,
    Map<String, dynamic>? metadata,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final session = await remoteDataSource.verifyPhoneAndRegister(
          phone: phone,
          code: code,
          name: name,
          invitationCode: invitationCode,
          metadata: metadata,
        );
        await localDataSource.cacheSession(_toAuthSessionModel(session));
        return Right(session);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearSession();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession?>> getCurrentSession() async {
    try {
      final session = await remoteDataSource.getCurrentSession();
      if (session != null) {
        await localDataSource.cacheSession(_toAuthSessionModel(session));
      }
      return Right(session);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}