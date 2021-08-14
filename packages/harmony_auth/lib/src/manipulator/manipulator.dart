import 'package:dio/dio.dart';

import 'impl/impl.dart';

/// harmony_auth manipulation applied on a request
/// when adding auth information
///
/// note: header maps are not case sensitive
abstract class AuthManipulator {
  /// standard implementation
  ///
  /// using `authorization` as header key and `Bearer $token` as value
  const factory AuthManipulator() = AuthManipulatorStandardImpl;

  /// general implementation
  ///
  /// do whatever using a lambda
  const factory AuthManipulator.general(
    void Function(RequestOptions request, String accessToken) lambda,
  ) = AuthManipulatorGeneralImpl;

  /// headers implementation
  ///
  /// add headers by using access token
  const factory AuthManipulator.headers(
    Map<String, String> Function(String accessToken) headers,
  ) = AuthManipulatorHeadersImpl;

  /// header implementation
  ///
  /// add one header by using access token
  const factory AuthManipulator.header(
    String key,
    String Function(String accessToken) value,
  ) = AuthManipulatorHeaderImpl;

  /// headerPrefixed implementation
  ///
  /// add one header by key and value
  /// made of a prefix and token.
  ///
  /// note: we do not add space between
  /// prefix and token.
  const factory AuthManipulator.headerPrefixed(
    String key,
    String valuePrefix,
  ) = AuthManipulatorHeaderPrefixedImpl;

  void manipulate(RequestOptions request, String accessToken);
}
