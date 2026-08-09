import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores the JWT access token in the Android Keystore-backed secure
/// storage, so it is not readable in plain text like a normal preference.
class AuthStorage {
  AuthStorage._internal();
  static final AuthStorage instance = AuthStorage._internal();

  static const _tokenKey = 'webalert_access_token';

  final FlutterSecureStorage _secure = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveToken(String token) => _secure.write(key: _tokenKey, value: token);

  /// Reads the stored token. flutter_secure_storage on Android can throw
  /// (e.g. a Keystore "BAD_DECRYPT" PlatformException) if the encryption
  /// key backing encryptedSharedPreferences becomes unreadable - this
  /// happens after some OS-level restore/backup scenarios even though the
  /// app's own data is otherwise intact. Uncaught, this exception used to
  /// propagate straight out of AuthProvider.restoreSession() during splash
  /// bootstrap, so "come back" (a fresh cold start) could fail to restore
  /// the session with no clean fallback. Treat any read failure the same
  /// as "no token" rather than letting it crash the auth check.
  Future<String?> readToken() async {
    try {
      return await _secure.read(key: _tokenKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearToken() => _secure.delete(key: _tokenKey);
}
