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
  Future<AuthToken?> geToken() async => await base.geToken();

  @override
  Future<void> setTokens(AuthToken token) async {
    await base.setTokens(token);
    _emit(AuthStatus.loggedIn);
  }

  @override
  Future<void> removeTokens() async {
    await base.removeTokens();
    _emit(AuthStatus.loggedOut);
  }

  void _emit(AuthStatus status) {
    _controller.add(status);
  }
}
