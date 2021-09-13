import 'package:flutter/material.dart';

class LoginUIEmailPassword extends StatelessWidget {
  const LoginUIEmailPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _onPressed(context),
      label: const Text('Login With Email'),
      icon: const Image(
        image: AssetImage('asset/image/email.png'),
        width: 32,
        height: 32,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginUIEPLogin(),
      ),
    );
  }
}

class LoginUIEPLogin extends StatefulWidget {
  const LoginUIEPLogin({
    Key? key,
  }) : super(key: key);

  @override
  _LoginUIEPLoginState createState() => _LoginUIEPLoginState();
}

class _LoginUIEPLoginState extends State<LoginUIEPLogin> {
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
                TextButton(
                  onPressed: _loading ? null : _register,
                  child: const Text('Register'),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: _loading ? null : _resetPassword,
                  child: const Text('Reset Password'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginUIEPRegister(),
      ),
    );
  }

  void _resetPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginUIEPResetPassword(),
      ),
    );
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }
}

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
                    hintText: 'Password',
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
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }
}

class LoginUIEPResetPassword extends StatefulWidget {
  const LoginUIEPResetPassword({Key? key}) : super(key: key);

  @override
  _LoginUIEPResetPasswordState createState() => _LoginUIEPResetPasswordState();
}

class _LoginUIEPResetPasswordState extends State<LoginUIEPResetPassword> {
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
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _resetPassword,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }
}
