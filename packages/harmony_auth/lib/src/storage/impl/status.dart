import 'dart:async';

import 'package:meta/meta.dart';

import '../../token/token.dart';
import '../storage.dart';

/// [AuthStorage] wrapper which provides
/// authentication state changes ...
///
/// use [statusStream] extension function for status stream.
///
/// use [internalInitializeStatusStream] to push initial state on stream.
/// this is optional.
@internal
class AuthStorageWithStatusWrapper implements AuthStorage {
  final AuthStorage storage;

  AuthStorageWithStatusWrapper(this.storage);

  final _controller = StreamController<AuthStatus>();

  /// stream of states
  @internal
  Stream<AuthStatus> get internalStatusStream => _controller.stream;

  /// push initial state on stream.
  /// this is optional.
  @internal
  Future<void> internalInitializeStatusStream() async {
    _emit(await status);
  }

  @override
  Future<void> clear() async {
    await storage.removeRefreshToken();
    await storage.removeAccessToken();
    _emit(AuthStatus.loggedOut);
  }

  @override
  Future<String?> getAccessToken() async {
    return await storage.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await storage.getRefreshToken();
  }

  @override
  Future<void> removeAccessToken() async {
    await storage.removeAccessToken();
  }

  @override
  Future<void> removeRefreshToken() async {
    await storage.removeRefreshToken();
    _emit(AuthStatus.loggedOut);
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    await storage.setAccessToken(accessToken);
  }

  @override
  Future<void> setRefreshToken(String refreshToken) async {
    await storage.setRefreshToken(refreshToken);
    _emit(AuthStatus.loggedIn);
  }

  void _emit(AuthStatus status) {
    _controller.add(status);
  }
}
