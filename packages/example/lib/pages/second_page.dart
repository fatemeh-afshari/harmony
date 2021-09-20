import 'package:example/mocks/mocks.dart';
import 'package:flutter/material.dart';
import 'package:harmony_login_ui/harmony_login_ui.dart';

class SecondPage extends StatelessWidget {
  final String provider;
  final String email;
  final String? displayName;
  final bool? isRegistered;

  const SecondPage({
    Key? key,
    required this.provider,
    required this.email,
    this.displayName,
    this.isRegistered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text('provider: $provider'),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text('email: $email'),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text('displayName: $displayName'),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text('isRegistered: $isRegistered'),
              ),
              const SizedBox(height: 32),
              if (provider == 'email_password')
                ChangePasswordButton(
                  authRepository: const MockAuthRepository(),
                  loginSystem: const MockLoginSystem(),
                  onSuccess: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password Changed')),
                    );
                  },
                ),
              const Spacer(),
              LogoutButton(
                authRepository: const MockAuthRepository(),
                loginSystem: const MockLoginSystem(),
                onSuccess: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged Out')),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
