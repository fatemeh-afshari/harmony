import 'package:harmony_auth/harmony_auth.dart';

class InMemoryAuthStorage implements AuthStorage {
  String? access;
  String? refresh;

  InMemoryAuthStorage();

  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
  }

  @override
  Future<String?> getAccessToken() async => access;

  @override
  Future<String?> getRefreshToken() async => refresh;

  @override
  Future<void> removeAccessToken() async {
    access = null;
  }

  @override
  Future<void> removeRefreshToken() async {
    refresh = null;
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    access = accessToken;
  }

  @override
  Future<void> setRefreshToken(String refreshToken) async {
    refresh = refreshToken;
  }
}
