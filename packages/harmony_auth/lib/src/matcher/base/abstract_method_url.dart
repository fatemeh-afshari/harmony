import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../utils/uri_extensions.dart';
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
