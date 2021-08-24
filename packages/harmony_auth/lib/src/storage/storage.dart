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

  /// get token
  ///
  /// it can throw [AuthStorageException] on
  /// non-recoverable errors.
  ///
  /// it will clear database on inconsistencies.
  Future<AuthToken?> getToken();

  /// set token
  ///
  /// it can throw [AuthStorageException] on
  /// non-recoverable errors.
  ///
  /// it will clear database on inconsistencies.
  Future<void> setToken(AuthToken token);

  /// remove token
  ///
  /// it can throw [AuthStorageException] on
  /// non-recoverable errors.
  ///
  /// it will clear database on inconsistencies.
  Future<void> removeToken();

  /// check status by checking if token is available or not.
  ///
  /// this is available if you add [streaming] functionality.
  /// otherwise unimplemented error is thrown.
  Future<AuthStatus> get status;

  /// status stream
  ///
  /// it will provide only changes in status.
  /// if you want to get initial state in stream use
  /// [initializeStatusStream].
  ///
  /// this is available if you add [streaming] functionality.
  /// otherwise unimplemented error is thrown.
  Stream<AuthStatus> get statusStream;

  /// initialize status stream
  ///
  /// it will emit current state in stream.
  ///
  /// this is available if you add [streaming] functionality.
  /// otherwise unimplemented error is thrown.
  Future<void> initializeStatusStream();
}

/// harmony_auth extensions for adding
/// streaming support to [AuthStorage]
extension AuthStorageStreamingExt on AuthStorage {
  /// streaming implementation
  ///
  /// provide status getter.
  /// and wrap this storage with status listener
  /// which provides authentication state changes ...
  ///
  /// use [statusStream] or [statusStreamOrNull]
  /// extension function for status stream.
  ///
  /// use [initializeStatusStream] extension function to push
  /// initial state on stream. this is optional.
  ///
  /// it should be wrapped first with lock then status.
  AuthStorage streaming() => AuthStorageStreamingImpl(this);
}

/// harmony_auth extensions for adding
/// concurrency support to [AuthStorage]
extension AuthStorageLockedExt on AuthStorage {
  /// locked implementation
  ///
  /// wrap an AuthStorage with lock to enable concurrency support.
  ///
  /// NOTE: standard (or maybe custom) implementations only
  /// need to be wrapped with lock.
  ///
  /// it should be wrapped first with lock then status.
  AuthStorage locked() => AuthStorageLockedImpl(this);
}

/// harmony_auth storage exception
///
/// this will happen in rare cases when
/// a non-recoverable error occurs.
abstract class AuthStorageException implements Exception {}
