import 'package:meta/meta.dart';

/// access and refresh token pair
@internal
@immutable
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
