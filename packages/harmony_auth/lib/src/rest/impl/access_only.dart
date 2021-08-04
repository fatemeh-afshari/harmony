import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../auth.dart';
import '../../exception/exception.dart';
import '../../matcher/matcher.dart';
import '../../utils/error_extensions.dart';
import '../../utils/intermediate_error_extensions.dart';
import '../rest.dart';

@internal
class AuthRestAccessOnlyImpl implements AuthRest {
  final Dio dio;
  final String refreshUrl;

  const AuthRestAccessOnlyImpl({
    required this.dio,
    required this.refreshUrl,
  });

  @override
  Future<AuthRestToken> refreshTokens(String refresh) async {
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
        'refresh': refresh,
      },
    );
    try {
      final response = await dio.fetch<dynamic>(request);
      _log('call was successful');
      try {
        final data = response.data as Map<String, dynamic>;
        return AuthRestToken(
          // using the same refresh token:
          refresh: refresh,
          access: data['access'] as String,
        );
      } catch (_) {
        // should not happen, but handling loosely ...
        _log('failed to parse response');
        throw DioError(
          requestOptions: request,
          type: DioErrorType.other,
          response: null,
          error: AssertionError('failed to parse refresh tokens api response.'),
        );
      }
    } on DioError catch (e) {
      if (e.isUnauthorized) {
        _log('call failed due to invalid refresh token');
        throw AuthException().toDioError(request);
      } else {
        rethrow;
      }
    }
  }

  @override
  AuthMatcher get refreshTokensMatcher {
    return AuthMatcher.url(refreshUrl) & AuthMatcher.method('POST');
  }

  void _log(String message) {
    Auth.log('harmony_auth rest.accessOnly: $message');
  }
}
