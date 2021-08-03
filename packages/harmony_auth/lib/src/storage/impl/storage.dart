import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage.dart';

/// auth storage implementation based on shared_preferences
@internal
@immutable
class AuthStorageImpl implements AuthStorage {
  static const _keyAccessToken = 'harmony_auth_storage_access_token';
  static const _keyRefreshToken = 'harmony_auth_storage_refresh_token';

  final Logger logger;
  final bool isInternal;

  const AuthStorageImpl({
    required this.logger,
    required this.isInternal,
  });

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
    _logI('set access token');
    final prefs = await _preferences();
    if (!await prefs.setString(_keyAccessToken, accessToken)) {
      throw AssertionError();
    }
  }

  @override
  Future<void> removeAccessToken() async {
    _logI('remove access token');
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
    _logI('set refresh token');
    final prefs = await _preferences();
    if (!await prefs.setString(_keyRefreshToken, refreshToken)) {
      throw AssertionError();
    }
  }

  @override
  Future<void> removeRefreshToken() async {
    _logI('remove refresh token');
    final prefs = await _preferences();
    if (!await prefs.remove(_keyRefreshToken)) {
      throw AssertionError();
    }
  }

  @override
  Future<void> clear() async {
    _logI('clear');
    await removeAccessToken();
    await removeRefreshToken();
  }

  void _logI(String message) {
    final s = StringBuffer('harmony_auth storage ');
    if (!isInternal) {
      s.write('EXTERNAL');
    }
    s.write(': ');
    s.write(message);
    logger.i(s.toString());
  }
}
