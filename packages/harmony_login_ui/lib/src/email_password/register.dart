import 'package:flutter/material.dart';

class LoginUIEPRegister extends StatefulWidget {
  const LoginUIEPRegister({Key? key}) : super(key: key);

  @override
  _LoginUIEPRegisterState createState() => _LoginUIEPRegisterState();
}

class _LoginUIEPRegisterState extends State<LoginUIEPRegister> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  autofillHints: const ['email'],
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  autofillHints: const ['password'],
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  autofillHints: const ['password'],
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _register,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }
}
