import 'package:dio/dio.dart';

import '../rest/rest.dart';
import '../storage/storage.dart';
import '../token/token.dart';
import 'impl/impl.dart';
import 'subset.dart';

/// harmony_auth refresh.
///
/// this is a wrapper around rest and storage.
///
/// it should perform operations in a `atomic` way.
abstract class AuthRepository implements AuthRepositorySubset {
  /// standard implementation
  const factory AuthRepository({
    required AuthStorage storage,
    required AuthRest rest,
  }) = AuthRepositoryStandardImpl;

  /// withLock implementation
  ///
  /// wrap an AuthRepository with lock to enable concurrency support.
  ///
  /// it should be wrapped first with lock then debounce.
  factory AuthRepository.wrapWithLock(
    AuthRepository base,
  ) = AuthRepositoryWithLockImpl;

  /// withDebounce implementation
  ///
  /// wrap an AuthRepository with debouncing to disallow too many
  /// token refresh calls in a timed window.
  ///
  /// it should be wrapped first with lock then debounce.
  factory AuthRepository.wrapWithDebounce(
    AuthRepository base, {
    required Duration duration,
  }) = AuthRepositoryWithDebounceImpl;

  /// refresh and store tokens.
  ///
  /// either throw [DioError] on errors related to rest.
  /// it could be a network problem.
  /// or throw [AuthException] if there is no token.
  @override
  Future<void> refreshTokens();

  /// get token
  @override
  Future<AuthToken?> getToken();

  /// set token
  ///
  /// ONLY FOR EXTERNAL USE
  Future<void> setToken(AuthToken token);

  /// remove token
  ///
  /// ONLY FOR EXTERNAL USE
  Future<void> removeToken();
}

/// extensions to add concurrency support to [AuthRepository].
extension AuthRepositoryLockExt on AuthRepository {
  /// wrap an AuthRepository with lock to enable concurrency support.
  ///
  /// it should be wrapped first with lock then debounce.
  AuthRepository wrapWithLock() => AuthRepository.wrapWithLock(this);
}

/// extensions to add debouncing support to [AuthRepository].
extension AuthRepositoryDebounceExt on AuthRepository {
  /// wrap an AuthRepository with debouncing to disallow too many
  /// token refresh calls in a timed window.
  ///
  /// it should be wrapped first with lock then debounce.
  AuthRepository wrapWithDebounce(Duration duration) =>
      AuthRepository.wrapWithDebounce(
        this,
        duration: duration,
      );
}
