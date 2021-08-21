import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../auth.dart';
import '../../checker/checker.dart';
import '../../exception/exception.dart';
import '../../matcher/matcher.dart';
import '../../token/token.dart';
import '../rest.dart';

@internal
class AuthRestStandardImpl implements AuthRest {
  final Dio dio;
  final String refreshUrl;
  final AuthChecker checker;

  const AuthRestStandardImpl({
    required this.dio,
    required this.refreshUrl,
    required this.checker,
  });

  @override
  Future<AuthToken> refreshTokens(String refreshToken) async {
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
        'refresh': refreshToken,
      },
    );
    try {
      final response = await dio.fetch<dynamic>(request);
      _log('call was successful');
      try {
        final data = response.data as Map<String, dynamic>;
        return AuthToken(
          refresh: data['refresh'] as String,
          access: data['access'] as String,
        );
      } catch (_) {
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
        throw AuthException();
      } else {
        rethrow;
      }
    }
  }

  @override
  AuthMatcher get refreshTokensMatcher =>
      AuthMatcher.methodAndUrl('POST', refreshUrl);

  void _log(String message) {
    Auth.log('harmony_auth rest.standard: $message');
  }
}
