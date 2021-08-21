import '../token/token.dart';
import 'impl/impl.dart';

/// harmony_auth storage for tokens
///
/// it will be backed by shared_preferences by default
abstract class AuthStorage {
  /// persisted using shared preferences
  const factory AuthStorage() = AuthStorageStandardImpl;

  /// in memory implementation
  factory AuthStorage.inMemory() = AuthStorageInMemoryImpl;

  /// [AuthStorage] wrapper which provides
  /// authentication state changes ...
  ///
  /// use [statusStream] or [statusStreamOrNull]
  /// extension function for status stream.
  ///
  /// use [initializeStatusStream] extension function to push
  /// initial state on stream. this is optional.
  factory AuthStorage.wrapWithStatus(AuthStorage storage) =
      AuthStorageWithStatusWrapper;

  Future<String?> getAccessToken();

  Future<void> setAccessToken(String accessToken);

  Future<void> removeAccessToken();

  Future<String?> getRefreshToken();

  Future<void> setRefreshToken(String refreshToken);

  Future<void> removeRefreshToken();

  Future<void> clear();
}

/// extension for checking login state
extension AuthStorageExt on AuthStorage {
  Future<AuthStatus> get status async => await getRefreshToken() != null
      ? AuthStatus.loggedIn
      : AuthStatus.loggedOut;

  /// if this storage is an storage wrapped with status,
  /// by using [AuthStorageWithStatusWrapper] then return
  /// status stream otherwise return null.
  Stream<AuthStatus>? get statusStreamOrNull {
    final storage = this;
    return storage is AuthStorageWithStatusWrapper
        ? storage.internalStatusStream
        : null;
  }

  /// if this storage is an storage wrapped with status,
  /// by using [AuthStorageWithStatusWrapper] then return
  /// status stream otherwise throw assertion error;
  Stream<AuthStatus> get statusStream {
    final storage = this;
    return storage is AuthStorageWithStatusWrapper
        ? storage.internalStatusStream
        : throw AssertionError();
  }

  /// if this storage is an storage wrapped with status,
  /// by using [AuthStorageWithStatusWrapper] initialize
  /// status stream by pushing initial state on stream,
  /// otherwise do nothing.
  Future<void> initializeStatusStreamOrNothing() async {
    final storage = this;
    if (storage is AuthStorageWithStatusWrapper) {
      await storage.internalInitializeStatusStream();
    }
  }

  /// if this storage is an storage wrapped with status,
  /// by using [AuthStorageWithStatusWrapper] initialize
  /// status stream by pushing initial state on stream,
  /// otherwise throw assertion error.
  Future<void> initializeStatusStream() async {
    final storage = this;
    if (storage is AuthStorageWithStatusWrapper) {
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
  AuthStorage wrapWithStatus() => AuthStorage.wrapWithStatus(this);
}
