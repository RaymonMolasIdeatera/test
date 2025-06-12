import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prueba/domain/usecases/auth/login_user.dart';

import '../../../domain/entities/auth_session.dart';
import '../../../domain/usecases/auth/check_auth_status.dart';
import '../../../domain/usecases/auth/login_with_biometric.dart';
import '../../../domain/usecases/auth/login_with_oauth.dart';
import '../../../domain/usecases/auth/logout.dart';
import '../../../domain/usecases/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatus checkAuthStatus;
  final LoginWithBiometric loginWithBiometric;
  final LoginWithOAuth loginWithOAuth;
  final Logout logout;
  final LoginUser loginUser;

  AuthBloc({
    required this.checkAuthStatus,
    required this.loginWithBiometric,
    required this.loginWithOAuth,
    required this.logout,
    required this.loginUser,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<BiometricLoginRequested>(_onBiometricLoginRequested);
    on<OAuthLoginRequested>(_onOAuthLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<LoginWithEmailPasswordRequested>(_onLoginWithEmailPasswordRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await checkAuthStatus(NoParams());
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (session) {
        if (session != null && session.isValid) {
          emit(AuthAuthenticated(session: session));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginWithBiometric(NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (session) => emit(AuthAuthenticated(session: session)),
    );
  }

  Future<void> _onOAuthLoginRequested(
    OAuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginWithOAuth(OAuthParams(provider: event.provider));
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (session) => emit(AuthAuthenticated(session: session)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logout(NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onLoginWithEmailPasswordRequested(
    LoginWithEmailPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUser(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (session) => emit(AuthAuthenticated(session: session)),
    );
  }
}