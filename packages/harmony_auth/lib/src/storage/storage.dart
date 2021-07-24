import 'dart:async';

/// auth storage for tokens
abstract class AuthStorage {
  Future<String?> getAccessToken();

  Future<void> setAccessToken(String token);

  Future<void> removeAccessToken();

  Future<String?> getRefreshToken();

  Future<void> setRefreshToken(String refreshToken);

  Future<void> removeRefreshToken();

  Future<void> clear();
}
