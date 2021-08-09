import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../utils/uri_utils.dart';
import 'abstract_matcher.dart';

/// basic utilities for set operations
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
