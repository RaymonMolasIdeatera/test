part of 'invitation_bloc.dart';

abstract class InvitationState extends Equatable {
  const InvitationState();

  @override
  List<Object> get props => [];
}

class InvitationInitial extends InvitationState {}

class InvitationValidating extends InvitationState {}

class InvitationValid extends InvitationState {
  final String invitationCode;

  const InvitationValid({required this.invitationCode});

  @override
  List<Object> get props => [invitationCode];
}

class InvitationError extends InvitationState {
  final String message;

  const InvitationError({required this.message});

  @override
  List<Object> get props => [message];
}
