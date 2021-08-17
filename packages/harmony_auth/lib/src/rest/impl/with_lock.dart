import 'dart:async';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../matcher/matcher.dart';
import '../../utils/error_extensions.dart';
import '../rest.dart';

/// this is only applicable to standard refresh token
@internal
class AuthRestWithLockImpl implements AuthRest {
  // we don't expect to face a lot of unauthenticated
  // refresh token calls, so a simple in memory cache
  // without expire time will suffice.
  final cache = <String, Completer<AuthRestToken>?>{};

  final AuthRest rest;

  AuthRestWithLockImpl(this.rest);

  @override
  Future<AuthRestToken> refreshTokens(final String refresh) async {
    final cachedCompleter = cache[refresh];
    if (cachedCompleter != null) {
      return cachedCompleter.future;
    } else {
      final completer = Completer<AuthRestToken>();
      cache[refresh] = completer;
      try {
        final value = await rest.refreshTokens(refresh);
        completer.complete(value);
      } on DioError catch (error) {
        completer.completeError(error);
        if (!error.isAuthException) {
          // we faced an error which does is not related
          // to refresh token being invalidated. So we should
          // be able to retry our request. For example in
          // case of network availability issues.
          cache[refresh] = null;
        }
      } catch (_) {
        throw AssertionError('bad error type.');
      }
      return completer.future;
    }
  }

  @override
  AuthMatcher get refreshTokensMatcher => rest.refreshTokensMatcher;
}
