import 'impl/impl.dart';

/// Matchers to include/exclude urls from authentication
///
/// NOTE: do NOT throw in matchers
abstract class AuthMatcher {
  /// provide regex or string to match exactly
  factory AuthMatcher.url(Pattern urlPattern) = AuthMatcherUrlImpl;

  /// provide regex or string to match exactly
  ///
  /// should not be empty
  factory AuthMatcher.urls(Set<Pattern> urlPatterns) = AuthMatcherUrlsImpl;

  /// base url matching
  ///
  /// should end with '/'
  factory AuthMatcher.baseUrl(String baseUrl) = AuthMatcherBaseUrlImpl;

  /// base url matching
  ///
  /// should end with '/'
  ///
  /// should not be empty
  factory AuthMatcher.baseUrls(Set<String> baseUrls) = AuthMatcherBaseUrlsImpl;

  /// provide lambda for url
  factory AuthMatcher.byUrl(bool Function(String url) matchUrl) =
      AuthMatcherByUrlImpl;

  /// provide regex or string to match exactly
  factory AuthMatcher.method(Pattern methodPattern) = AuthMatcherMethodImpl;

  /// provide regex or string to match exactly
  ///
  /// should not be empty
  factory AuthMatcher.methods(Set<Pattern> methodPatterns) =
      AuthMatcherMethodsImpl;

  /// provide lambda for method
  factory AuthMatcher.byMethod(bool Function(String method) matchMethod) =
      AuthMatcherByMethodImpl;

  /// always match
  factory AuthMatcher.all() = AuthMatcherAllImpl;

  /// never match
  factory AuthMatcher.none() = AuthMatcherNoneImpl;

  /// method will be upper case
  ///
  /// url will be all but queries
  bool matches(String method, String url);

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
