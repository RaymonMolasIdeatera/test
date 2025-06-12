import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/auth/verify_invitation.dart';

part 'invitation_event.dart';
part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final VerifyInvitation verifyInvitation;

  InvitationBloc({required this.verifyInvitation})
    : super(InvitationInitial()) {
    on<InvitationCodeSubmitted>(_onInvitationCodeSubmitted);
    on<InvitationCodeChanged>(_onInvitationCodeChanged);
    on<InvitationReset>(_onInvitationReset);
  }

  Future<void> _onInvitationCodeSubmitted(
    InvitationCodeSubmitted event,
    Emitter<InvitationState> emit,
  ) async {
    emit(InvitationValidating());

    final result = await verifyInvitation(
      InvitationParams(invitationCode: event.invitationCode),
    );

    result.fold((failure) => emit(InvitationError(message: failure.message)), (
      isValid,
    ) {
      if (isValid) {
        emit(InvitationValid(invitationCode: event.invitationCode));
      } else {
        emit(
          InvitationError(
            message: 'Invalid invitation code. Please check and try again.',
          ),
        );
      }
    });
  }

  void _onInvitationCodeChanged(
    InvitationCodeChanged event,
    Emitter<InvitationState> emit,
  ) {
    if (state is InvitationError || state is InvitationValid) {
      emit(InvitationInitial());
    }
  }

  void _onInvitationReset(
    InvitationReset event,
    Emitter<InvitationState> emit,
  ) {
    emit(InvitationInitial());
  }
}
