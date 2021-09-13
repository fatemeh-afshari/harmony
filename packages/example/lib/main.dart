import 'package:example/backends/email_password.dart';
import 'package:example/backends/social_apple.dart';
import 'package:example/backends/social_facebook.dart';
import 'package:example/backends/social_google.dart';
import 'package:flutter/material.dart';

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
          children: const [
            Expanded(
              child: FlutterLogo(),
            ),
            SizedBox(height: 32),
            LoginUIEmailPassword(),
            SizedBox(height: 32),
            LoginUIGoogle(),
            SizedBox(height: 32),
            LoginUIFacebook(),
            SizedBox(height: 32),
            LoginUIApple(),
          ],
        ),
      ),
    );
  }
}
