import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
  Future<Map<String, String>> readAll();
}

class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorageImpl(this.secureStorage);

  @override
  Future<void> write(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    return await secureStorage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await secureStorage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await secureStorage.deleteAll();
  }

  @override
  Future<Map<String, String>> readAll() async {
    return await secureStorage.readAll();
  }
}
