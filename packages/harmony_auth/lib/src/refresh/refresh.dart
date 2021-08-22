import 'package:dio/dio.dart';

import '../rest/rest.dart';
import '../storage/storage.dart';
import '../token/token.dart';
import 'impl/impl.dart';

/// harmony_auth refresh.
///
/// this is a wrapper around rest and storage.
///
/// it should perform operations in a `atomic` way.
abstract class AuthRefresh {
  /// standard implementation
  const factory AuthRefresh({
    required AuthStorage storage,
    required AuthRest rest,
  }) = AuthRefreshStandardImpl;

  /// withLock implementation
  ///
  /// wrap an AuthRefresh with lock to enable concurrency support.
  ///
  /// it should be wrapped first with lock then debounce.
  factory AuthRefresh.wrapWithLock(
    AuthRefresh base,
  ) = AuthRefreshWithLockImpl;

  /// withDebounce implementation
  ///
  /// wrap an AuthRefresh with debouncing to disallow too many
  /// token refresh calls in a timed window.
  ///
  /// it should be wrapped first with lock then debounce.
  factory AuthRefresh.wrapWithDebounce(
    AuthRefresh base, {
    required Duration duration,
  }) = AuthRefreshWithDebounceImpl;

  /// refresh and store tokens.
  ///
  /// return new token on success.
  ///
  /// either throw [DioError] on errors related to rest.
  /// it could be a network problem.
  /// [isAuthException] will be true on auth exception.
  /// or throw [AuthException] if there is no token.
  Future<void> refresh();

  /// get token
  Future<AuthToken?> get();

  /// set token
  ///
  /// ONLY FOR USER
  Future<void> set(AuthToken token);

  /// remove token
  ///
  /// ONLY FOR USER
  Future<void> remove();
}

/// extensions to add concurrency support to [AuthRefresh].
extension AuthRefreshLockExt on AuthRefresh {
  /// wrap an AuthRefresh with lock to enable concurrency support.
  ///
  /// it should be wrapped first with lock then debounce.
  AuthRefresh wrapWithLock() => AuthRefresh.wrapWithLock(this);
}

/// extensions to add debouncing support to [AuthRefresh].
extension AuthRefreshDebounceExt on AuthRefresh {
  /// wrap an AuthRefresh with debouncing to disallow too many
  /// token refresh calls in a timed window.
  ///
  /// it should be wrapped first with lock then debounce.
  AuthRefresh wrapWithDebounce(Duration duration) =>
      AuthRefresh.wrapWithDebounce(
        this,
        duration: duration,
      );
}
