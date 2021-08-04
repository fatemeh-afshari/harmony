import 'impl/persisted.dart';

/// harmony_auth storage for tokens
///
/// it will be backed by shared_preferences by default
abstract class AuthStorage {
  /// persisted using shared preferences
  const factory AuthStorage.standard() = AuthStorageStandardImpl;

  Future<String?> getAccessToken();

  Future<void> setAccessToken(String accessToken);

  Future<void> removeAccessToken();

  Future<String?> getRefreshToken();

  Future<void> setRefreshToken(String refreshToken);

  Future<void> removeRefreshToken();

  Future<void> clear();
}

/// extension for checking login state
extension AuthStorageExt on AuthStorage {
  Future<bool> get isLoggedIn async => await getRefreshToken() != null;
}
