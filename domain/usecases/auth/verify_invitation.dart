import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

class VerifyInvitation implements UseCase<bool, InvitationParams> {
  final AuthRepository repository;

  VerifyInvitation(this.repository);

  @override
  Future<Either<Failure, bool>> call(InvitationParams params) async {
    return await repository.verifyInvitation(params.invitationCode);
  }
}

class InvitationParams extends Equatable {
  final String invitationCode;

  const InvitationParams({required this.invitationCode});

  @override
  List<Object> get props => [invitationCode];
}
