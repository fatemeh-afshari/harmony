import 'package:example/mocks.dart';
import 'package:flutter/material.dart';
import 'package:harmony_login_ui/harmony_login_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harmony Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                    builder: (context) => LoggedInPage(
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
                    builder: (context) => LoggedInPage(
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
                    builder: (context) => LoggedInPage(
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
                    builder: (context) => LoggedInPage(
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

class LoggedInPage extends StatelessWidget {
  final String provider;
  final String email;
  final String? displayName;
  final bool? isRegistered;

  const LoggedInPage({
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
                const Center(
                  child: Text('Change Password'),
                ),
              const Spacer(),
              const Center(
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
