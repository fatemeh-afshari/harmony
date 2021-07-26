import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../exception/exception.dart';
import '../matcher/matcher.dart';
import '../model/token_pair.dart';
import '../storage/storage.dart';

/// interceptor for [Dio] to handle auth
@immutable
@internal
class AuthInterceptor implements Interceptor {
  static const _keyIsRetry = 'harmony_auth_interceptor_is_retry';

  final String refreshUrl;

  final Dio dio;

  final Logger logger;

  final AuthStorage storage;

  final AuthMatcher matcher;

  const AuthInterceptor({
    required this.refreshUrl,
    required this.dio,
    required this.logger,
    required this.storage,
    required this.matcher,
  });

  /// note: artificial DioErrors should NOT have response
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldHandle(options)) {
      _logI('request needs handling, checking access token ...');
      final access1 = await storage.getAccessToken();
      if (access1 != null) {
        _logI('access token is available, attempting to call ...');
        options.headers['AUTHORIZATION'] = 'Bearer $access1';
        handler.next(options);
      } else {
        _logI('access token is NOT available, checking refresh token ...');
        final refresh1 = await storage.getRefreshToken();
        if (refresh1 != null) {
          _logI('refresh token is available, attempting to refresh ...');
          try {
            final pair2 = await _refreshTokens(refresh1);
            _logI('got new tokens, attempting to call ...');
            final refresh2 = pair2.refresh;
            final access2 = pair2.access;
            await storage.setRefreshToken(refresh2);
            await storage.setAccessToken(access2);
            options.headers['AUTHORIZATION'] = 'Bearer $access2';
            handler.next(options);
          } on DioError catch (e) {
            // check to see if refresh token was invalid
            if (e.type == DioErrorType.other && e.error is AuthException) {
              _logI('refresh token is not valid, error');
              await storage.removeRefreshToken();
            }
            handler.reject(
              DioError(
                requestOptions: options,
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
            DioError(
              requestOptions: options,
              type: DioErrorType.other,
              response: null,
              error: AuthException('refresh-token-not-available'),
            ),
            true,
          );
        }
      }
    } else {
      handler.next(options);
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
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (_shouldHandle(options)) {
      _logI('error needs handling, checking retry status ...');
      final isRetry = options.extra[_keyIsRetry] != null;
      if (isRetry) {
        _logI('request is on retry already, NOT handling ...');
        handler.next(err);
      } else {
        _logI('request is NOT on retry, checking status code ...');
        if (err.type == DioErrorType.response &&
            err.response?.statusCode == 401) {
          _logI('unauthorized invalid access token, attempting to retry ...');
          await storage.removeAccessToken();
          options.extra[_keyIsRetry] = true;
          try {
            // todo: type ? for example text plain !
            final response = await dio.fetch<dynamic>(options);
            handler.resolve(response);
          } on DioError catch (e) {
            handler.reject(e);
          }
        } else {
          handler.next(err);
        }
      }
    } else {
      handler.next(err);
    }
  }

  /// note: should NOT contain queries
  ///
  /// note: should start with http(s)
  String _extractUrl(Uri uri) {
    final str = uri.toString();
    final index = str.indexOf('?');
    return index == -1 ? str : str.substring(0, index);
  }

  /// note: should not handle refresh api calls as well as
  /// not matcher calls
  bool _shouldHandle(RequestOptions request) {
    final method = request.method;
    final url = _extractUrl(request.uri);
    // maybe refreshUrl comes as relative or full format
    return !(url == refreshUrl || request.path == refreshUrl) &&
        matcher.matches(method, url);
  }

  /// note: should ONLY throw DioError
  ///
  /// note: should NOT do anything other than making request,
  /// such as writing to storage ...
  Future<AuthTokenPair> _refreshTokens(String refresh) async {
    _logI('rest, calling refresh token api');
    // build options for refresh request
    final options = Options(method: 'POST').compose(
      dio.options,
      refreshUrl,
      data: {
        'refresh': refresh,
      },
    );
    try {
      final response = await dio.fetch<dynamic>(options);
      _logI('rest, call was successful');
      try {
        final data = response.data as Map<String, dynamic>;
        return AuthTokenPair(
          refresh: data['refresh'] as String,
          access: data['access'] as String,
        );
      } catch (_) {
        // should not happen, but handling loosely ...
        _logI('rest, failed to parse response');
        throw DioError(
          requestOptions: options,
          type: DioErrorType.other,
          response: null,
          error: AuthException('refresh-api-bad-response'),
        );
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.response && e.response?.statusCode == 401) {
        _logI('rest, call failed due to invalid refresh token');
        throw DioError(
          requestOptions: options,
          type: DioErrorType.other,
          response: null,
          error: AuthException('refresh-api-invalid-refresh-token'),
        );
      } else {
        rethrow;
      }
    }
  }

  void _logI(String message) {
    logger.i('harmony_auth interceptor $message');
  }
}
