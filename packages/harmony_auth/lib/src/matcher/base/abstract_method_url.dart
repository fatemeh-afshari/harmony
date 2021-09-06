import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'abstract.dart';

/// basic utilities extracting method and url
@internal
abstract class AbstractMethodUrlAuthMatcher extends AbstractAuthMatcher {
  const AbstractMethodUrlAuthMatcher();

  /// method will be upper case
  ///
  /// url will be all but queries
  bool matches(String method, String url);

  /// implemented by extracting method and url from request options
  @override
  bool matchesRequest(RequestOptions options) =>
      matches(options.method, options.uri.url);
}

/// utilities to extract url from [Uri] to match
/// against it.
@internal
extension AuthUriExt on Uri {
  /// note: output should NOT contain queries
  ///
  /// note: output should start with http(s)
  ///
  /// todo: what about port ?
  @internal
  String get url {
    final str = toString();
    final index = str.indexOf('?');
    return index == -1 ? str : str.substring(0, index);
  }
}
