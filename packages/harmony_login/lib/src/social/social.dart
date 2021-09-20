import 'package:harmony_login/src/result/result.dart';

/// social backend
abstract class LoginSocial {
  /// login
  Future<LoginResult> login({
    required String provider,
    required String email,
  });
}
