import 'package:example/mocks/mocks.dart';
import 'package:example/pages/second_page.dart';
import 'package:flutter/material.dart';
import 'package:harmony_login_ui/harmony_login_ui.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: FlutterLogo(),
              ),
              const SizedBox(height: 32),
              EmailPasswordLoginButton(
                authRepository: const MockAuthRepository(),
                loginSystem: const MockLoginSystem(),
                onSuccess: (String provider, String email, bool isRegistered) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SecondPage(
                      provider: provider,
                      email: email,
                      isRegistered: isRegistered,
                    ),
                  ));
                },
              ),
              const SizedBox(height: 32),
              SocialLoginButton.google(
                authRepository: const MockAuthRepository(),
                loginSystem: const MockLoginSystem(),
                fireSigning: const MockFireSigning(),
                onSuccess: (provider, email, displayName) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SecondPage(
                      provider: provider,
                      email: email,
                      displayName: displayName,
                    ),
                  ));
                },
              ),
              const SizedBox(height: 32),
              SocialLoginButton.facebook(
                authRepository: const MockAuthRepository(),
                loginSystem: const MockLoginSystem(),
                fireSigning: const MockFireSigning(),
                onSuccess: (provider, email, displayName) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SecondPage(
                      provider: provider,
                      email: email,
                      displayName: displayName,
                    ),
                  ));
                },
              ),
              const SizedBox(height: 32),
              SocialLoginButton.apple(
                authRepository: const MockAuthRepository(),
                loginSystem: const MockLoginSystem(),
                fireSigning: const MockFireSigning(),
                onSuccess: (provider, email, displayName) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SecondPage(
                      provider: provider,
                      email: email,
                      displayName: displayName,
                    ),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
