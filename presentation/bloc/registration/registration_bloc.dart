import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/register_user.dart';
import '../../../domain/usecases/auth/login_with_oauth.dart';
import 'registration_event.dart';
import 'registration_state.dart';
import '../../../core/error/failures.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterUser registerUser;
  final LoginWithOAuth loginWithOAuth;

  RegistrationBloc({required this.registerUser, required this.loginWithOAuth})
    : super(RegistrationInitial()) {
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<RegisterWithOAuthEvent>(_onRegisterWithOAuth);
    on<RegisterWithPhoneEvent>(_onRegisterWithPhone);
    on<VerifyPhoneCodeEvent>(_onVerifyPhoneCode);
  }

  Future<void> _onRegisterWithEmail(
    RegisterWithEmailEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    final result = await registerUser(
      RegisterUserParams(
        email: event.email,
        password: event.password,
        name: event.name,
        phone: event.phone,
        invitationCode: event.invitationCode,
        metadata: event.metadata,
      ),
    );

    result.fold(
      (failure) => emit(RegistrationError(_mapFailureToMessage(failure))),
      (session) => emit(RegistrationSuccess(session)),
    );
  }

  Future<void> _onRegisterWithOAuth(
    RegisterWithOAuthEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    // CORRECCIÓN LÍNEA 51: Crear instancia de la clase correctamente
    final params = OAuthParams(provider: event.provider);
    final result = await loginWithOAuth(params);

    result.fold(
      (failure) => emit(RegistrationError(_mapFailureToMessage(failure))),
      (session) => emit(RegistrationSuccess(session)),
    );
  }

  Future<void> _onRegisterWithPhone(
    RegisterWithPhoneEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    // Para MVP, simular envío de SMS
    await Future.delayed(const Duration(seconds: 2));

    // Emitir estado especial para mostrar pantalla de verificación
    emit(
      RegistrationPhoneVerificationSent(
        phone: event.phone,
        name: event.name,
        invitationCode: event.invitationCode,
        metadata: event.metadata,
      ),
    );
  }

  Future<void> _onVerifyPhoneCode(
    VerifyPhoneCodeEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    // Para MVP, simular verificación
    await Future.delayed(const Duration(seconds: 2));

    if (event.code == '123456') {
      // Código correcto simulado
      // Aquí normalmente llamarías al método real de verificación
      emit(RegistrationError('Phone registration will be available soon'));
    } else {
      emit(RegistrationError('Invalid verification code'));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      // CORRECCIÓN LÍNEAS 100, 102: Usar patrones correctos con _
      case ServerFailure _:
        return 'Server error occurred. Please try again.';
      case NetworkFailure _:
        return 'Network error. Please check your connection.';
      // CORRECCIÓN LÍNEA 104: Cambiar AuthFailure por AuthenticationFailure
      case AuthenticationFailure _:
        return 'Authentication failed. Please check your credentials.';
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}