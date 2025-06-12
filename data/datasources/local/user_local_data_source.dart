import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../core/error/exceptions.dart';
import '../../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel?> getCachedUserProfile();
  Future<void> cacheUserProfile(UserModel user);
  Future<void> clearUserCache();
  Future<double?> getCachedBalance();
  Future<void> cacheBalance(double balance);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({required this.sharedPreferences});

  static const String _userProfileKey = 'cached_user_profile';
  static const String _userBalanceKey = 'cached_user_balance';

  @override
  Future<UserModel?> getCachedUserProfile() async {
    try {
      final userData = sharedPreferences.getString(_userProfileKey);
      if (userData == null) return null;

      final userMap = json.decode(userData) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      throw CacheException('Failed to get cached user profile: $e');
    }
  }

  @override
  Future<void> cacheUserProfile(UserModel user) async {
    try {
      final userData = json.encode(user.toJson());
      await sharedPreferences.setString(_userProfileKey, userData);
    } catch (e) {
      throw CacheException('Failed to cache user profile: $e');
    }
  }

  @override
  Future<void> clearUserCache() async {
    try {
      await sharedPreferences.remove(_userProfileKey);
      await sharedPreferences.remove(_userBalanceKey);
    } catch (e) {
      throw CacheException('Failed to clear user cache: $e');
    }
  }

  @override
  Future<double?> getCachedBalance() async {
    try {
      return sharedPreferences.getDouble(_userBalanceKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheBalance(double balance) async {
    try {
      await sharedPreferences.setDouble(_userBalanceKey, balance);
    } catch (e) {
      throw CacheException('Failed to cache balance: $e');
    }
  }
}
