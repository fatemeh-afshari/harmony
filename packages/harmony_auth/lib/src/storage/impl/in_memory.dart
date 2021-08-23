import 'package:meta/meta.dart';

import '../../auth.dart';
import '../../token/token.dart';
import '../storage.dart';

/// auth storage in memory implementation
@internal
class AuthStorageInMemoryImpl implements AuthStorage {
  AuthToken? memory;

  AuthStorageInMemoryImpl();

  @override
  Future<AuthToken?> getToken() async => memory;

  @override
  Future<void> removeToken() async {
    memory = null;
    _log('remove');
  }

  @override
  Future<void> setToken(AuthToken token) async {
    _log('set');
    memory = token;
  }

  void _log(String message) {
    Auth.log('harmony_auth storage.inMemory: $message');
  }
}
