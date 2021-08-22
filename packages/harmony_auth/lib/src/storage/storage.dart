import '../token/token.dart';
import 'impl/impl.dart';

/// harmony_auth storage for tokens
///
/// it will be backed by shared_preferences by default
abstract class AuthStorage {
  /// standard implementation
  ///
  ///persisted using shared preferences
  const factory AuthStorage() = AuthStorageStandardImpl;

  /// inMemory implementation
  factory AuthStorage.inMemory() = AuthStorageInMemoryImpl;

  /// withStatus implementation
  ///
  /// [AuthStorage] wrapper which provides
  /// authentication state changes ...
  ///
  /// use [statusStream] or [statusStreamOrNull]
  /// extension function for status stream.
  ///
  /// use [initializeStatusStream] extension function to push
  /// initial state on stream. this is optional.
  ///
  /// it should be wrapped first with lock then status.
  factory AuthStorage.streaming(AuthStorage base) = AuthStorageStreamingImpl;

  /// locked implementation
  ///
  /// wrap an AuthStorage with lock to enable concurrency support.
  ///
  /// NOTE: standard (or maybe custom) implementations only
  /// need to be wrapped with lock.
  ///
  /// it should be wrapped first with lock then status.
  factory AuthStorage.locked(AuthStorage base) = AuthStorageLockedImpl;

  /// get token
  Future<AuthToken?> getToken();

  /// set token
  Future<void> setTokens(AuthToken token);

  /// remove token
  Future<void> removeTokens();
}

/// extension for checking login state
extension AuthStorageStatusExt on AuthStorage {
  Future<AuthStatus> get status async =>
      await getToken() != null ? AuthStatus.loggedIn : AuthStatus.loggedOut;

  /// if this storage is an storage wrapped with status,
  /// by using [AuthStorageStreamingImpl] then return
  /// status stream otherwise return null.
  Stream<AuthStatus>? get statusStreamOrNull {
    final storage = this;
    return storage is AuthStorageStreamingImpl
        ? storage.internalStatusStream
        : null;
  }

  /// if this storage is an storage wrapped with status,
  /// by using [AuthStorageStreamingImpl] then return
  /// status stream otherwise throw assertion error.
  Stream<AuthStatus> get statusStream {
    final storage = this;
    return storage is AuthStorageStreamingImpl
        ? storage.internalStatusStream
        : throw AssertionError();
  }

  /// if this storage is an storage wrapped with status,
  /// by using [AuthStorageStreamingImpl] initialize
  /// status stream by pushing initial state on stream,
  /// otherwise do nothing.
  Future<void> initializeStatusStreamOrNothing() async {
    final storage = this;
    if (storage is AuthStorageStreamingImpl) {
      await storage.internalInitializeStatusStream();
    }
  }

  /// if this storage is an storage wrapped with status,
  /// by using [AuthStorageStreamingImpl] initialize
  /// status stream by pushing initial state on stream,
  /// otherwise throw assertion error.
  Future<void> initializeStatusStream() async {
    final storage = this;
    if (storage is AuthStorageStreamingImpl) {
      await storage.internalInitializeStatusStream();
    } else {
      throw AssertionError();
    }
  }

  /// wrap this storage with status listener
  /// which provides authentication state changes ...
  ///
  /// use [statusStream] or [statusStreamOrNull]
  /// extension function for status stream.
  ///
  /// use [initializeStatusStream] extension function to push
  /// initial state on stream. this is optional.
  ///
  /// it should be wrapped first with lock then status.
  AuthStorage streaming() => AuthStorage.streaming(this);
}

/// extensions for adding concurrency support to [AuthStorage]
extension AuthStorageLockExt on AuthStorage {
  /// wrap an AuthStorage with lock to enable concurrency support.
  ///
  /// NOTE: standard (or maybe custom) implementations only
  /// need to be wrapped with lock.
  ///
  /// it should be wrapped first with lock then status.
  AuthStorage locked() => AuthStorage.locked(this);
}
