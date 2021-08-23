import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../matcher/matcher.dart';
import '../rest/rest.dart';
import '../storage/storage.dart';
import '../token/token.dart';
import 'impl/impl.dart';

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

  /// locked implementation
  ///
  /// wrap an AuthRepository with lock to enable concurrency support.
  ///
  /// it should be wrapped first with lock then debounce.
  factory AuthRepository.locked(
    AuthRepository base,
  ) = AuthRepositoryLockedImpl;

  /// debounce implementation
  ///
  /// wrap an AuthRepository with debouncing to disallow too many
  /// token refresh calls in a timed window.
  ///
  /// it should be wrapped first with lock then debounce.
  factory AuthRepository.debounce(
    AuthRepository base, {
    required Duration duration,
  }) = AuthRepositoryDebounceImpl;

  /// refresh and store tokens.
  ///
  /// either throw [DioError] on errors related to rest.
  /// it could be a network problem.
  /// or throw [AuthRepositoryException] if there is no token,
  /// or after the refresh call token is found
  /// to be invalid and be removed.
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
  AuthRepository locked() => AuthRepository.locked(this);
}

/// extensions to add debouncing support to [AuthRepository].
extension AuthRepositoryDebounceExt on AuthRepository {
  /// wrap an AuthRepository with debouncing to disallow too many
  /// token refresh calls in a timed window.
  ///
  /// it should be wrapped first with lock then debounce.
  AuthRepository debounce(Duration duration) => AuthRepository.debounce(
        this,
        duration: duration,
      );
}

/// harmony_auth repository exception
///
/// this will happen when we have no tokens,
/// or after the refresh call token is found
/// to be invalid and be removed.
abstract class AuthRepositoryException implements Exception {}

/// subset [AuthRepository] to avoid usage of
/// external methods internally.
@internal
abstract class AuthRepositorySubset {
  /// refer to [AuthRepository]
  Future<void> refreshTokens();

  /// matcher to check to see if this call is from refresh tokens.
  @internal
  AuthMatcher get refreshTokensMatcher;

  /// refer to [AuthRepository]
  Future<AuthToken?> getToken();
}
