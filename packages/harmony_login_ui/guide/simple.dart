import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_fire/harmony_fire.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/harmony_login_ui.dart';

LoginSystem get loginSystem => throw UnimplementedError();

FireSigning get fireSigning => throw UnimplementedError();

AuthRepository get authRepository => throw UnimplementedError();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EmailPasswordLoginButton(
                authRepository: authRepository,
                loginSystem: loginSystem,
                onSuccess: (String provider, String email, bool isRegistered) {
                  // ...
                },
              ),
              const SizedBox(height: 32),
              SocialLoginButton.google(
                authRepository: authRepository,
                loginSystem: loginSystem,
                fireSigning: fireSigning,
                onSuccess: (provider, email, displayName) {
                  // ...
                },
              ),
              const SizedBox(height: 32),
              SocialLoginButton.facebook(
                authRepository: authRepository,
                loginSystem: loginSystem,
                fireSigning: fireSigning,
                onSuccess: (provider, email, displayName) {
                  // ...
                },
              ),
              const SizedBox(height: 32),
              SocialLoginButton.apple(
                authRepository: authRepository,
                loginSystem: loginSystem,
                fireSigning: fireSigning,
                onSuccess: (provider, email, displayName) {
                  // ...
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ChangePasswordButton(
                authRepository: authRepository,
                loginSystem: loginSystem,
                onSuccess: () {
                  // ...
                },
              ),
              const SizedBox(height: 32),
              LogoutButton(
                authRepository: authRepository,
                loginSystem: loginSystem,
                onSuccess: () {
                  // ...
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
