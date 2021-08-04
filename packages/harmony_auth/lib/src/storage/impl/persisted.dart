import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth.dart';
import '../storage.dart';

/// auth storage implementation based on shared_preferences
@internal
class AuthStorageStandardImpl implements AuthStorage {
  static const _keyAccessToken = 'harmony_auth_storage_access_token';
  static const _keyRefreshToken = 'harmony_auth_storage_refresh_token';

  const AuthStorageStandardImpl();

  Future<SharedPreferences> _preferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<String?> getAccessToken() async {
    final prefs = await _preferences();
    return prefs.getString(_keyAccessToken);
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    _log('set access token');
    final prefs = await _preferences();
    if (!await prefs.setString(_keyAccessToken, accessToken)) {
      throw AssertionError();
    }
  }

  @override
  Future<void> removeAccessToken() async {
    _log('remove access token');
    final prefs = await _preferences();
    if (!await prefs.remove(_keyAccessToken)) {
      throw AssertionError();
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    final prefs = await _preferences();
    return prefs.getString(_keyRefreshToken);
  }

  @override
  Future<void> setRefreshToken(String refreshToken) async {
    _log('set refresh token');
    final prefs = await _preferences();
    if (!await prefs.setString(_keyRefreshToken, refreshToken)) {
      throw AssertionError();
    }
  }

  @override
  Future<void> removeRefreshToken() async {
    _log('remove refresh token');
    final prefs = await _preferences();
    if (!await prefs.remove(_keyRefreshToken)) {
      throw AssertionError();
    }
  }

  @override
  Future<void> clear() async {
    _log('clear');
    await removeAccessToken();
    await removeRefreshToken();
  }

  void _log(String message) {
    Auth.log('harmony_auth storage.persisted: $message');
  }
}
