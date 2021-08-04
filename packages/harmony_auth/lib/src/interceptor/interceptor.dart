import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../auth.dart';
import '../exception/exception.dart';
import '../matcher/matcher.dart';
import '../rest/rest.dart';
import '../storage/storage.dart';
import '../utils/error_extensions.dart';
import '../utils/intermediate_error_extensions.dart';
import '../utils/uri_utils.dart';

/// interceptor for [Dio] to handle auth
@immutable
@internal
class AuthInterceptor implements Interceptor {
  static const _keyIsRetry = 'harmony_auth_is_retry';

  final Dio dio;
  final AuthStorage storage;
  final AuthMatcher matcher;
  final AuthRest rest;

  const AuthInterceptor({
    required this.dio,
    required this.storage,
    required this.matcher,
    required this.rest,
  });

  /// note: artificial DioErrors should NOT have response
  @override
  Future<void> onRequest(
    RequestOptions request,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldHandle(request)) {
      _logI('request needs handling, checking access token ...');
      final access1 = await storage.getAccessToken();
      if (access1 != null) {
        _logI('access token is available, attempting to call ...');
        request.headers['authorization'] = 'bearer $access1';
        handler.next(request);
      } else {
        _logI('access token is NOT available, checking refresh token ...');
        final refresh1 = await storage.getRefreshToken();
        if (refresh1 != null) {
          _logI('refresh token is available, attempting to refresh ...');
          try {
            final pair2 = await rest.refreshTokens(refresh1);
            _logI('got new tokens, attempting to call ...');
            final refresh2 = pair2.refresh;
            final access2 = pair2.access;
            await storage.setRefreshToken(refresh2);
            await storage.setAccessToken(access2);
            request.headers['authorization'] = 'bearer $access2';
            handler.next(request);
          } on DioError catch (e) {
            // check to see if refresh token was invalid
            if (e.isAuthException) {
              _logI('refresh token is not valid, error');
              await storage.removeRefreshToken();
            }
            handler.reject(
              DioError(
                requestOptions: request,
                // propagate type,
                // being 'other' on auth exception
                type: e.type,
                response: null,
                // propagate error,
                // being of type 'AuthException' on auth exception
                error: e.error,
              ),
              true,
            );
          }
        } else {
          _logI('refresh token is NOT available, error');
          handler.reject(
            AuthException().toDioError(request),
            true,
          );
        }
      }
    } else {
      handler.next(request);
    }
  }

  /// nothing to do
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  /// note: should retry only once
  @override
  Future<void> onError(
    DioError error,
    ErrorInterceptorHandler handler,
  ) async {
    final request = error.requestOptions;
    if (_shouldHandle(request) && error.isUnauthorized) {
      _logI('unauthorized, error needs handling, checking retry status ...');
      await storage.removeAccessToken();
      if (request.extra[_keyIsRetry] != null) {
        _logI('request is already retried, error');
        await storage.removeRefreshToken();
        handler.reject(
          AuthException().toDioError(request),
        );
      } else {
        _logI('request is NOT retried, attempting to retry ...');
        request.extra[_keyIsRetry] = true;
        try {
          final response = await dio.fetch<dynamic>(request);
          handler.resolve(response);
        } on DioError catch (e) {
          handler.reject(e);
        }
      }
    } else {
      handler.next(error);
    }
  }

  /// note: should not handle refresh api calls as well as
  /// not matcher calls
  bool _shouldHandle(RequestOptions request) {
    final combine = matcher - rest.refreshTokensMatcher;
    return combine.matches(request.method, request.uri.url);
  }

  void _logI(String message) {
    Auth.log('harmony_auth interceptor $message');
  }
}
