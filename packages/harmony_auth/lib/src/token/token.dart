/// harmony_auth token pair
class AuthToken {
  /// refresh token
  final String refresh;

  /// access token
  final String access;

  /// extra data.
  ///
  /// can be null.
  ///
  /// it will be copy-pasted when token is refreshed.
  ///
  /// THIS should be json encode/decode able.
  /// for example can be primitive, list or hashmap ...
  final dynamic extra;

  const AuthToken({
    required this.refresh,
    required this.access,
    this.extra,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthToken &&
          runtimeType == other.runtimeType &&
          refresh == other.refresh &&
          access == other.access;

  @override
  int get hashCode => refresh.hashCode ^ access.hashCode;

  @override
  String toString() => 'AuthToken{refresh: $refresh, access: $access}';
}

/// harmony_auth status of auth storage
enum AuthStatus {
  /// we have token in our storage
  loggedIn,

  /// we don't have token in our storage
  loggedOut,
}
