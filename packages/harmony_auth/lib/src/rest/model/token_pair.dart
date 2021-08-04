/// access and refresh token pair
class AuthTokenPair {
  /// refresh token
  final String refresh;

  /// access token
  final String access;

  const AuthTokenPair({
    required this.refresh,
    required this.access,
  });
}
