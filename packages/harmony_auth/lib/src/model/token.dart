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

  @override
  String toString() => 'TokenPair{refresh: $refresh, access: $access}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthTokenPair &&
          runtimeType == other.runtimeType &&
          refresh == other.refresh &&
          access == other.access;

  @override
  int get hashCode => runtimeType.hashCode ^ refresh.hashCode ^ access.hashCode;
}
