import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  AuthStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';

  // Явно отключаем EncryptedSharedPreferences и используем
  // стандартное хранилище, которое работает стабильнее.
  static const _options = AndroidOptions();

  Future<String?> readToken() =>
      _storage.read(key: _tokenKey, aOptions: _options);

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token, aOptions: _options);

  Future<void> clearToken() =>
      _storage.delete(key: _tokenKey, aOptions: _options);
}
