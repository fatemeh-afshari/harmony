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
}

/// harmony_auth status of auth storage
enum AuthStatus {
  /// we have token in our storage
  loggedIn,

  /// we don't have token in our storage
  loggedOut,
}
