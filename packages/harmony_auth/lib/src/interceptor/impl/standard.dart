import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../config/config.dart';
import '../../checker/checker.dart';
import '../../manipulator/manipulator.dart';
import '../../matcher/matcher.dart';
import '../../repository/repository.dart';
import '../../storage/storage.dart';
import '../interceptor.dart';

/// interceptor for [Dio] to handle auth
@internal
class AuthInterceptorStandardImpl implements AuthInterceptor {
  final Dio dio;
  final AuthMatcher matcher;
  final AuthChecker checker;
  final AuthManipulator manipulator;
  final AuthRepositoryInternalSubset repository;

  const AuthInterceptorStandardImpl({
    required this.dio,
    required this.matcher,
    required this.checker,
    required this.manipulator,
    required this.repository,
  });

  @override
  Future<void> onRequest(
    RequestOptions request,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldHandle(request)) {
      try {
        _log('request needs handling, checking token ...');
        final token = await repository.getToken();
        if (token != null) {
          _log('token is available, attempting to call ...');
          manipulator.manipulate(request, token);
          handler.next(request);
        } else {
          _log('token is not available, error');
          handler.reject(
            AuthExceptionStandardImpl().toDioError(request),
            true,
          );
        }
      } on AuthStorageException {
        _log('storage exception occurred, error');
        // todo: what to do ?
        handler.reject(
          AuthExceptionStandardImpl().toDioError(request),
          true,
        );
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
    if (_shouldHandle(request) && checker.isUnauthorizedError(error)) {
      _log('unauthorized, error needs handling, checking retry status ...');
      if (request.isOnRetry()) {
        _log('request is already retried, error');
        handler.reject(
          // do not allow for too many retries
          // but do not use [AuthException] too mimic
          // other types of exceptions like socket exception.
          Exception('too many retries').toDioError(request),
        );
      } else {
        _log('request is NOT retried, attempting to refresh tokens ...');
        try {
          await repository.refreshTokens();
        } on DioError catch (e) {
          handler.reject(
            DioError(
              requestOptions: request,
              type: e.type,
              response: null,
              error: e.error,
            ),
          );
          return;
        } on AuthRepositoryException {
          _log('could not refresh tokens, error');
          handler.reject(
            AuthExceptionStandardImpl().toDioError(request),
          );
          return;
        } on AuthStorageException {
          _log('storage exception occurred, error');
          // todo: what to do ?
          handler.reject(
            AuthExceptionStandardImpl().toDioError(request),
          );
        } on Object catch (e) {
          // should not happen but handling loosely ...
          handler.reject(
            e.toDioError(request),
          );
          return;
        }
        _log('refreshed tokens successfully, trying to retry ...');
        try {
          request.setOnRetry();
          final response = await dio.fetch<dynamic>(request);
          handler.resolve(response);
        } on DioError catch (e) {
          handler.reject(e);
        } on Object catch (e) {
          // should not happen but handling loosely ...
          handler.reject(
            e.toDioError(request),
          );
        }
      }
    } else {
      handler.next(error);
    }
  }

  /// note: should not handle refresh api calls as well as
  /// not matcher calls
  bool _shouldHandle(RequestOptions request) =>
      !repository.refreshTokensMatcher.matchesRequest(request) &&
      matcher.matchesRequest(request);

  void _log(String message) {
    AuthConfig.logI('interceptor.standard: $message');
  }
}

/// set and get retry status on [RequestOptions]
@internal
extension AuthRequestOptionsRetryExt on RequestOptions {
  static const _key = 'harmony_auth_retry';

  /// should not be const for security reasons ... :D
  static final _value = Object();

  /// set retry flag to true
  @internal
  void setOnRetry() => extra[_key] = _value;

  /// check if retry flag is available
  @internal
  bool isOnRetry() => identical(extra[_key], _value);
}

@internal
class AuthExceptionStandardImpl implements AuthException {
  const AuthExceptionStandardImpl();

  @override
  String toString() => 'AuthException.standard';
}

///extensions to transform an [Object] to [DioError].
@internal
extension AuthErrorExt on Object {
  /// transform an [Object] to [DioError].
  @internal
  DioError toDioError(RequestOptions request) => DioError(
        requestOptions: request,
        type: DioErrorType.other,
        response: null,
        error: this,
      );
}
