part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class BiometricLoginRequested extends AuthEvent {}

class OAuthLoginRequested extends AuthEvent {
  final String provider;

  const OAuthLoginRequested({required this.provider});

  @override
  List<Object> get props => [provider];
}

class LogoutRequested extends AuthEvent {}

class LoginWithEmailPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailPasswordRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}