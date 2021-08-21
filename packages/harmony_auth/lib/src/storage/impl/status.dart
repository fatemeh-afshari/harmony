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
  Future<AuthToken?> get() async => await storage.get();

  @override
  Future<void> set(AuthToken token) async {
    await storage.set(token);
    _emit(AuthStatus.loggedIn);
  }

  @override
  Future<void> remove() async {
    await storage.remove();
    _emit(AuthStatus.loggedOut);
  }

  void _emit(AuthStatus status) {
    _controller.add(status);
  }
}
