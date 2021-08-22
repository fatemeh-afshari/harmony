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
  Future<AuthToken?> geToken() async => await storage.geToken();

  @override
  Future<void> setTokens(AuthToken token) async {
    await storage.setTokens(token);
    _emit(AuthStatus.loggedIn);
  }

  @override
  Future<void> removeTokens() async {
    await storage.removeTokens();
    _emit(AuthStatus.loggedOut);
  }

  void _emit(AuthStatus status) {
    _controller.add(status);
  }
}
