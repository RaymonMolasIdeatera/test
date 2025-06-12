import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class RegisterWithEmailEvent extends RegistrationEvent {
  final String email;
  final String password;
  final String name;
  final String? phone;
  final String? invitationCode;
  final Map<String, dynamic>? metadata;

  const RegisterWithEmailEvent({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
    this.invitationCode,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    name,
    phone,
    invitationCode,
    metadata,
  ];
}

class RegisterWithOAuthEvent extends RegistrationEvent {
  final String provider;
  final String? invitationCode;
  final Map<String, dynamic>? metadata;

  const RegisterWithOAuthEvent({
    required this.provider,
    this.invitationCode,
    this.metadata,
  });

  @override
  List<Object?> get props => [provider, invitationCode, metadata];
}

class RegisterWithPhoneEvent extends RegistrationEvent {
  final String phone;
  final String name;
  final String? invitationCode;
  final Map<String, dynamic>? metadata;

  const RegisterWithPhoneEvent({
    required this.phone,
    required this.name,
    this.invitationCode,
    this.metadata,
  });

  @override
  List<Object?> get props => [phone, name, invitationCode, metadata];
}

class VerifyPhoneCodeEvent extends RegistrationEvent {
  final String phone;
  final String code;
  final String name;
  final String? invitationCode;
  final Map<String, dynamic>? metadata;

  const VerifyPhoneCodeEvent({
    required this.phone,
    required this.code,
    required this.name,
    this.invitationCode,
    this.metadata,
  });

  @override
  List<Object?> get props => [phone, code, name, invitationCode, metadata];
}
