import 'package:equatable/equatable.dart';
import 'user.dart'; // Agregar esta importación

class AuthSession extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final User user;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  @override
  List<Object> get props => [accessToken, refreshToken, expiresAt, user];

  bool get isValid => DateTime.now().isBefore(expiresAt);
}