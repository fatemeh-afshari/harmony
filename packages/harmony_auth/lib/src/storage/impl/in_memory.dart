import 'package:meta/meta.dart';

import '../../auth.dart';
import '../storage.dart';

/// auth storage in memory implementation
@internal
class AuthStorageInMemoryImpl implements AuthStorage {
  String? access;
  String? refresh;

  AuthStorageInMemoryImpl();

  @override
  Future<String?> getAccessToken() async => access;

  @override
  Future<String?> getRefreshToken() async => refresh;

  @override
  Future<void> removeAccessToken() async {
    _log('removeAccessToken');
    access = null;
  }

  @override
  Future<void> removeRefreshToken() async {
    _log('removeRefreshToken');
    refresh = null;
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    _log('setAccessToken');
    access = accessToken;
  }

  @override
  Future<void> setRefreshToken(String refreshToken) async {
    _log('setRefreshToken');
    refresh = refreshToken;
  }

  @override
  Future<void> clear() async {
    _log('clear');
    access = null;
    refresh = null;
  }

  void _log(String message) {
    Auth.log('harmony_auth storage.inMemory: $message');
  }
}
