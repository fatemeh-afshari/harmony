import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth.dart';
import '../../token/token.dart';
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
  Future<AuthToken?> geToken() async {
    final prefs = await _preferences();
    final refresh = prefs.getString(_keyRefreshToken);
    final access = prefs.getString(_keyAccessToken);
    if (refresh != null && access != null) {
      return AuthToken(
        refresh: refresh,
        access: access,
      );
    } else if (refresh == null && access == null) {
      return null;
    } else {
      // inconsistency !?
      // should not happen !
      await removeTokens();
      return null;
    }
  }

  @override
  Future<void> setTokens(AuthToken token) async {
    _log('set');
    final prefs = await _preferences();
    await prefs.setStringAndAssert(_keyRefreshToken, token.refresh);
    await prefs.setStringAndAssert(_keyAccessToken, token.access);
  }

  @override
  Future<void> removeTokens() async {
    _log('remove');
    final prefs = await _preferences();
    await prefs.removeAndAssert(_keyRefreshToken);
    await prefs.removeAndAssert(_keyAccessToken);
  }

  void _log(String message) {
    Auth.log('harmony_auth storage.persisted: $message');
  }
}

/// extensions to check if operation completes normally
@internal
extension SharedPreferencesAssertionExt on SharedPreferences {
  /// remove and assert
  Future<void> removeAndAssert(String key) async {
    if (!await remove(key)) {
      throw AssertionError();
    }
  }

  /// set string and assert
  Future<void> setStringAndAssert(String key, String value) async {
    if (!await setString(key, value)) {
      throw AssertionError();
    }
  }
}
