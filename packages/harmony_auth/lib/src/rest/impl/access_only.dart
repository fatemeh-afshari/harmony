import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../config/config.dart';
import '../../checker/checker.dart';
import '../../matcher/matcher.dart';
import '../../token/token.dart';
import '../rest.dart';

@internal
class AuthRestAccessOnlyImpl implements AuthRest {
  final Dio dio;
  final String refreshUrl;
  final AuthChecker checker;

  const AuthRestAccessOnlyImpl({
    required this.dio,
    required this.refreshUrl,
    required this.checker,
  });

  @override
  Future<AuthToken> refreshTokens(AuthToken token) async {
    _log('calling refresh token api');
    // build request for refresh request
    final request = Options(
      method: 'POST',
      headers: <String, dynamic>{
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    ).compose(
      dio.options,
      refreshUrl,
      data: {
        'refresh': token.refresh,
      },
    );
    try {
      final response = await dio.fetch<dynamic>(request);
      _log('call was successful');
      try {
        final data = response.data as Map<String, dynamic>;
        return AuthToken(
          // using the same refresh token:
          refresh: token.refresh,
          access: data['access'] as String,
          extra: token.extra,
        );
      } on Object {
        // should not happen, but handling loosely ...
        _log('failed to parse response');
        throw DioError(
          requestOptions: request,
          type: DioErrorType.other,
          response: null,
          error: Exception('failed to parse refresh tokens api response.'),
        );
      }
    } on DioError catch (error) {
      if (checker.isUnauthorizedError(error)) {
        _log('call failed due to invalid refresh token');
        throw AuthRestExceptionAccessOnlyImpl();
      } else {
        rethrow;
      }
    }
  }

  @override
  AuthMatcher get refreshTokensMatcher =>
      AuthMatcher.methodAndUrl('POST', refreshUrl);

  void _log(String message) {
    AuthConfig.logI('rest.accessOnly: $message');
  }
}

@internal
class AuthRestExceptionAccessOnlyImpl implements AuthRestException {
  const AuthRestExceptionAccessOnlyImpl();

  @override
  String toString() => 'AuthRestException.accessOnly';
}
