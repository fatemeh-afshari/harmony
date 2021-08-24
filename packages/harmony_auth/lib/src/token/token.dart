/// harmony_auth token pair
class AuthToken {
  /// refresh token
  final String refresh;

  /// access token
  final String access;

  const AuthToken({
    required this.refresh,
    required this.access,
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
