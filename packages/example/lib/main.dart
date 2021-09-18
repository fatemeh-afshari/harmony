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
      body: Padding(
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
              onSuccess: (String email) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('email: $email'),
                ));
              },
            ),
            const SizedBox(height: 32),
            SocialLoginButton.google(
              authRepository: const MockAuthRepository(),
              loginSystem: const MockLoginSystem(),
              fireSigning: const MockFireSigning(),
              onSuccess: (email, displayName) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('email: $email, name: $displayName'),
                ));
              },
            ),
            const SizedBox(height: 32),
            SocialLoginButton.facebook(
              authRepository: const MockAuthRepository(),
              loginSystem: const MockLoginSystem(),
              fireSigning: const MockFireSigning(),
              onSuccess: (email, displayName) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('email: $email, name: $displayName'),
                ));
              },
            ),
            const SizedBox(height: 32),
            SocialLoginButton.apple(
              authRepository: const MockAuthRepository(),
              loginSystem: const MockLoginSystem(),
              fireSigning: const MockFireSigning(),
              onSuccess: (email, displayName) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('email: $email, name: $displayName'),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
