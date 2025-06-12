import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

class UpdateUserProfile implements UseCase<User, UpdateProfileParams> {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await repository.updateUserProfile(
      name: params.name,
      username: params.username,
      phone: params.phone,
      avatarUrl: params.avatarUrl,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String? name;
  final String? username;
  final String? phone;
  final String? avatarUrl;

  const UpdateProfileParams({
    this.name,
    this.username,
    this.phone,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, username, phone, avatarUrl];
}
