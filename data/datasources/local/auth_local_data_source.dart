// lib/data/datasources/local/auth_local_data_source.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../core/storage/secure_storage.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/auth_session_model.dart';

abstract class AuthLocalDataSource {
  Future<AuthSessionModel?> getCachedSession();
  Future<AuthSessionModel?> getLastSession(); // Método faltante añadido
  Future<void> cacheSession(AuthSessionModel session);
  Future<void> clearSession();
  Future<bool> isBiometricEnabled();
  Future<void> setBiometricEnabled(bool enabled);
  Future<String?> getDeviceId();
  Future<void> setDeviceId(String deviceId);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<AuthSessionModel?> getCachedSession() async {
    try {
      final sessionData = await secureStorage.read(AppConstants.tokenKey);
      if (sessionData == null) return null;

      final sessionMap = json.decode(sessionData) as Map<String, dynamic>;
      return AuthSessionModel.fromJson(sessionMap);
    } catch (e) {
      throw CacheException('Failed to get cached session: $e');
    }
  }

  @override
  Future<AuthSessionModel?> getLastSession() async {
    // Alias para getCachedSession para mantener compatibilidad
    return await getCachedSession();
  }

  @override
  Future<void> cacheSession(AuthSessionModel session) async {
    try {
      final sessionData = json.encode(session.toJson());
      await secureStorage.write(AppConstants.tokenKey, sessionData);
      await secureStorage.write(
        AppConstants.refreshTokenKey,
        session.refreshToken,
      );
      await secureStorage.write(AppConstants.userIdKey, session.user.id);
      await secureStorage.write(
        AppConstants.walletAddressKey,
        session.user.walletAddress,
      );
    } catch (e) {
      throw CacheException('Failed to cache session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await secureStorage.delete(AppConstants.tokenKey);
      await secureStorage.delete(AppConstants.refreshTokenKey);
      await secureStorage.delete(AppConstants.userIdKey);
      await secureStorage.delete(AppConstants.walletAddressKey);
    } catch (e) {
      throw CacheException('Failed to clear session: $e');
    }
  }

  @override
  Future<bool> isBiometricEnabled() async {
    try {
      return sharedPreferences.getBool(AppConstants.biometricEnabledKey) ??
          false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await sharedPreferences.setBool(
        AppConstants.biometricEnabledKey,
        enabled,
      );
    } catch (e) {
      throw CacheException('Failed to set biometric preference: $e');
    }
  }

  @override
  Future<String?> getDeviceId() async {
    try {
      return await secureStorage.read(AppConstants.deviceIdKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setDeviceId(String deviceId) async {
    try {
      await secureStorage.write(AppConstants.deviceIdKey, deviceId);
    } catch (e) {
      throw CacheException('Failed to set device ID: $e');
    }
  }
}