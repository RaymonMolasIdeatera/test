part of 'invitation_bloc.dart';

abstract class InvitationEvent extends Equatable {
  const InvitationEvent();

  @override
  List<Object> get props => [];
}

class InvitationCodeSubmitted extends InvitationEvent {
  final String invitationCode;

  const InvitationCodeSubmitted({required this.invitationCode});

  @override
  List<Object> get props => [invitationCode];
}

class InvitationCodeChanged extends InvitationEvent {}

class InvitationReset extends InvitationEvent {}
