import 'impl/impl.dart';

/// Matchers to include or exclude urls from authentication
///
/// NOTE: do NOT throw in matchers
abstract class AuthMatcher {
  /// provide regex or string to match exactly
  const factory AuthMatcher.url(Pattern urlPattern) = AuthMatcherUrlImpl;

  /// provide regex or string to match exactly
  const factory AuthMatcher.urls(Set<Pattern> urlPatterns) =
      AuthMatcherUrlsImpl;

  /// base url matching
  const factory AuthMatcher.baseUrl(String baseUrl) = AuthMatcherBaseUrlImpl;

  /// base urls matching
  const factory AuthMatcher.baseUrls(Set<String> baseUrls) =
      AuthMatcherBaseUrlsImpl;

  /// provide lambda for url
  const factory AuthMatcher.byUrl(bool Function(String url) matchUrl) =
      AuthMatcherByUrlImpl;

  /// provide regex or string to match exactly
  const factory AuthMatcher.method(Pattern methodPattern) =
      AuthMatcherMethodImpl;

  /// provide regex or string to match exactly
  const factory AuthMatcher.methods(Set<Pattern> methodPatterns) =
      AuthMatcherMethodsImpl;

  /// provide lambda for method
  const factory AuthMatcher.byMethod(bool Function(String method) matchMethod) =
      AuthMatcherByMethodImpl;

  /// always match
  const factory AuthMatcher.all() = AuthMatcherAllImpl;

  /// never match
  const factory AuthMatcher.none() = AuthMatcherNoneImpl;

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
