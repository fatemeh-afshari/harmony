import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/widgets/email_form_field.dart';
import 'package:harmony_login_ui/src/widgets/loading_elevated_button.dart';
import 'package:harmony_login_ui/src/widgets/password_pair_form_field.dart';

class LoginUIEmailPasswordRegister extends StatefulWidget {
  static const route = '/harmony_login_ui/email_password/register';

  final AuthRepository authRepository;
  final LoginSystem loginSystem;

  const LoginUIEmailPasswordRegister({
    Key? key,
    required this.authRepository,
    required this.loginSystem,
  }) : super(key: key);

  @override
  _LoginUIEmailPasswordRegisterState createState() =>
      _LoginUIEmailPasswordRegisterState();
}

class _LoginUIEmailPasswordRegisterState
    extends State<LoginUIEmailPasswordRegister> {
  final _formKey = GlobalKey<FormState>();

  var _loading = false;

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EmailFromField(
                  onSaved: (value) => _email = value,
                ),
                const SizedBox(height: 32),
                PasswordPairFromField(
                  onSaved: (value) => _password = value,
                ),
                const Spacer(),
                LoginUILoadingElevatedButton(
                  title: 'Register',
                  loading: _loading,
                  onPressed: _register,
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
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final emailPassword = widget.loginSystem.emailPassword();
        final result = await emailPassword.register(
          email: _email!,
          password: _password!,
        );
        await widget.authRepository.setToken(AuthToken(
          refresh: result.refresh,
          access: result.access,
        ));
        Navigator.of(context).pop(<String, dynamic>{
          'loggedIn': true,
          'registered': true,
          'email': _email!,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form has problems')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A problem occurred')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
}
