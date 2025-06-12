class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

class BiometricException implements Exception {
  final String message;
  BiometricException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
