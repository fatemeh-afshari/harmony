import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'model/token_pair.dart';
import '../matcher/matcher.dart';

/// handle token refresh api calls.
@internal
abstract class AuthRest {
  /// note: should ONLY throw DioError.
  /// other error will be of [type] [DioErrorType.other]
  /// and they will have [error] of type [AuthException]
  ///
  /// note: should NOT do anything other than making request,
  /// such as writing to storage ...
  Future<AuthTokenPair> refreshTokens(String refresh);

  /// check to see if this call is to refresh tokens\
  AuthMatcher get refreshTokensMatcher;
}
