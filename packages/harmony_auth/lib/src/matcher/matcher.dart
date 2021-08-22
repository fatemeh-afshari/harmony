import 'package:dio/dio.dart';

import 'impl/impl.dart';

/// Matchers to include or exclude urls from authentication
///
/// NOTE: do NOT throw in matchers
///
/// note: [method] is always in upper case
abstract class AuthMatcher {
  /// provide regex or string to match exactly
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  const factory AuthMatcher.url(
    Pattern urlPattern,
  ) = AuthMatcherUrlImpl;

  /// provide regex or string to match exactly
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  const factory AuthMatcher.urls(
    Set<Pattern> urlPatterns,
  ) = AuthMatcherUrlsImpl;

  /// base url matching
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  const factory AuthMatcher.baseUrl(
    String baseUrl,
  ) = AuthMatcherBaseUrlImpl;

  /// base urls matching
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  const factory AuthMatcher.baseUrls(
    Set<String> baseUrls,
  ) = AuthMatcherBaseUrlsImpl;

  /// provide lambda for url
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  const factory AuthMatcher.byUrl(
    bool Function(String url) matchUrl,
  ) = AuthMatcherByUrlImpl;

  /// provide regex or string to match exactly
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  const factory AuthMatcher.method(
    Pattern methodPattern,
  ) = AuthMatcherMethodImpl;

  /// provide regex or string to match exactly
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  const factory AuthMatcher.methods(
    Set<Pattern> methodPatterns,
  ) = AuthMatcherMethodsImpl;

  /// provide lambda for method
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  const factory AuthMatcher.byMethod(
    bool Function(String method) matchMethod,
  ) = AuthMatcherByMethodImpl;

  /// method and url
  ///
  /// pattern or string
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  const factory AuthMatcher.methodAndUrl(
    Pattern methodPattern,
    Pattern urlPattern,
  ) = AuthMatcherMethodAndUrlImpl;

  /// method and base url
  ///
  /// pattern or string
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  factory AuthMatcher.methodAndBaseUrl(
    Pattern methodPattern,
    String baseUrl,
  ) = AuthMatcherMethodAndBaseUrlImpl;

  /// provide lambda for method and url
  ///
  /// method will be upper case
  ///
  /// url will be all but queries
  const factory AuthMatcher.byMethodAndUrl(
    bool Function(String method, String url) match,
  ) = AuthMatcherByMethodAndUrlImpl;

  /// always match
  const factory AuthMatcher.all() = AuthMatcherAllImpl;

  /// never match
  const factory AuthMatcher.none() = AuthMatcherNoneImpl;

  /// general matcher
  ///
  /// provide lambda to match
  const factory AuthMatcher.general(
    bool Function(RequestOptions request) lambda,
  ) = AuthMatcherGeneralImpl;

  /// check if matches request
  bool matchesRequest(RequestOptions request);

  /// union
  AuthMatcher operator |(AuthMatcher other);

  /// intersection
  AuthMatcher operator &(AuthMatcher other);

  /// difference
  AuthMatcher operator -(AuthMatcher other);

  /// symmetric difference
  AuthMatcher operator ^(AuthMatcher other);

  /// negate
  AuthMatcher operator -();
}
