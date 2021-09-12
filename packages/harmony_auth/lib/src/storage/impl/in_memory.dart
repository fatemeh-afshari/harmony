import 'package:meta/meta.dart';

import '../../config/config.dart';
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
    AuthConfig.log('harmony_auth storage.inMemory: $message');
  }

  @override
  Future<AuthStatus> get status async => throw UnimplementedError();

  @override
  Stream<AuthStatus> get statusStream => throw UnimplementedError();

  @override
  Future<void> initializeStatusStream() async => throw UnimplementedError();
}
