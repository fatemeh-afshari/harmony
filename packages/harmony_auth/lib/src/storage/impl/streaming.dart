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
class AuthStorageStreamingImpl implements AuthStorage {
  final AuthStorage base;

  AuthStorageStreamingImpl(this.base);

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
  Future<AuthToken?> getToken() async => await base.getToken();

  @override
  Future<void> setToken(AuthToken token) async {
    await base.setToken(token);
    _emit(AuthStatus.loggedIn);
  }

  @override
  Future<void> removeToken() async {
    await base.removeToken();
    _emit(AuthStatus.loggedOut);
  }

  void _emit(AuthStatus status) {
    _controller.add(status);
  }
}
