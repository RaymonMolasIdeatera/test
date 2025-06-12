import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_session.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final AuthSession session;

  const RegistrationSuccess(this.session);

  @override
  List<Object> get props => [session];
}

class RegistrationError extends RegistrationState {
  final String message;

  const RegistrationError(this.message);

  @override
  List<Object> get props => [message];
}

class RegistrationPhoneVerificationSent extends RegistrationState {
  final String phone;
  final String name;
  final String? invitationCode;
  final Map<String, dynamic>? metadata;

  const RegistrationPhoneVerificationSent({
    required this.phone,
    required this.name,
    this.invitationCode,
    this.metadata,
  });

  @override
  List<Object?> get props => [phone, name, invitationCode, metadata];
}
