import 'package:harmony_login/src/result/result.dart';

/// email-password backend
abstract class LoginEmailPassword {
  /// login
  Future<LoginResult> login({
    required String email,
    required String password,
  });

  /// register
  Future<LoginResult> register({
    required String email,
    required String password,
  });

  /// change password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  /// reset password
  Future<void> resetPassword({
    required String email,
  });

  /// reset password verify code
  Future<void> resetPasswordVerifyCode({
    required String email,
    required String code,
  });

  /// reset password set new password
  Future<LoginResult> resetPasswordNewPassword({
    required String email,
    required String code,
    required String password,
  });
}
