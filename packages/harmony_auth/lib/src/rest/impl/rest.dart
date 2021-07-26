import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../exception/exception.dart';
import '../model/token_pair.dart';
import '../rest.dart';

@internal
class AuthRestImpl implements AuthRest {
  final Dio dio;
  final String refreshUrl;
  final Logger logger;

  const AuthRestImpl({
    required this.dio,
    required this.refreshUrl,
    required this.logger,
  });

  @override
  Future<AuthTokenPair> refreshTokens(String refresh) async {
    _logI('calling refresh token api');
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
      _logI('call was successful');
      try {
        final data = response.data as Map<String, dynamic>;
        return AuthTokenPair(
          refresh: data['refresh'] as String,
          access: data['access'] as String,
        );
      } catch (_) {
        // should not happen, but handling loosely ...
        _logI('failed to parse response');
        throw DioError(
          requestOptions: options,
          type: DioErrorType.other,
          response: null,
          error: AssertionError('failed to parse refresh tokens api response.'),
        );
      }
    } on DioError catch (e) {
      if (_isUnauthorized(e)) {
        _logI('call failed due to invalid refresh token');
        throw DioError(
          requestOptions: options,
          type: DioErrorType.other,
          response: null,
          error: AuthException(),
        );
      } else {
        rethrow;
      }
    }
  }

  @override
  bool isRefreshTokens(RequestOptions requestOptions) {
    // should check both for relative and full url.
    // and there is no queries on refresh api.
    return requestOptions.path == refreshUrl ||
        requestOptions.uri.toString() == refreshUrl;
  }

  /// check if request was unauthorized
  bool _isUnauthorized(DioError e) {
    return e.type == DioErrorType.response && e.response?.statusCode == 401;
  }

  void _logI(String message) {
    logger.i('harmony_auth rest $message');
  }
}
