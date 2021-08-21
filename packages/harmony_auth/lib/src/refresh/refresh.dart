import 'package:dio/dio.dart';

import '../rest/rest.dart';
import '../storage/storage.dart';
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
  /// it should be wrapped first with lock then status.
  factory AuthRefresh.wrapWithLock(
    AuthRefresh base,
  ) = AuthRefreshWithLockImpl;

  /// refresh and store tokens.
  ///
  /// return new token on success.
  ///
  /// either throw [DioError] on errors related to rest.
  /// it could be a network problem.
  /// [isAuthException] will be true on auth exception.
  /// or throw [AuthException] if there is no token.
  Future<void> refresh();
}

/// extensions to add concurrency support to [AuthRefresh].
extension AuthRefreshLockExt on AuthRefresh {
  /// wrap an AuthRefresh with lock to enable concurrency support.
  ///
  /// it should be wrapped first with lock then status.
  AuthRefresh wrapWithLock() => AuthRefresh.wrapWithLock(this);
}
