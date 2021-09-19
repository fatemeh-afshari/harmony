import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/email_password/pages/register_page.dart';
import 'package:harmony_login_ui/src/email_password/pages/reset_password_page.dart';
import 'package:harmony_login_ui/src/widgets/email_form_field.dart';
import 'package:harmony_login_ui/src/widgets/loading_elevated_button.dart';
import 'package:harmony_login_ui/src/widgets/loading_text_button.dart';
import 'package:harmony_login_ui/src/widgets/password_form_field.dart';

class LoginUIEmailPasswordLogin extends StatefulWidget {
  static const route = '/harmony_login_ui/email_password/login';

  final AuthRepository authRepository;
  final LoginSystem loginSystem;

  const LoginUIEmailPasswordLogin({
    Key? key,
    required this.authRepository,
    required this.loginSystem,
  }) : super(key: key);

  @override
  _LoginUIEmailPasswordLoginState createState() =>
      _LoginUIEmailPasswordLoginState();
}

class _LoginUIEmailPasswordLoginState extends State<LoginUIEmailPasswordLogin> {
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
                PasswordFromField(
                  onSaved: (value) => _password = value,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Spacer(),
                    LoginUILoadingTextButton(
                      title: 'Reset Password',
                      loading: _loading,
                      showLoading: false,
                      onPressed: _loading ? null : _resetPassword,
                    ),
                  ],
                ),
                const Spacer(),
                LoginUILoadingTextButton(
                  title: 'Register',
                  loading: _loading,
                  showLoading: false,
                  onPressed: _loading ? null : _register,
                ),
                const SizedBox(height: 16),
                LoginUILoadingElevatedButton(
                  title: 'Login',
                  loading: _loading,
                  onPressed: _login,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    setState(() => _loading = true);
    final result = await Navigator.of(context).push(
      MaterialPageRoute<Object?>(
        settings: RouteSettings(
          name: LoginUIEmailPasswordRegister.route,
        ),
        builder: (context) => LoginUIEmailPasswordRegister(
          loginSystem: widget.loginSystem,
          authRepository: widget.authRepository,
        ),
      ),
    );
    if (result is Map<String, dynamic>) {
      Navigator.of(context).pop(result);
    }
    setState(() => _loading = false);
  }

  Future<void> _resetPassword() async {
    setState(() => _loading = true);
    final result = await Navigator.of(context).push(
      MaterialPageRoute<Object?>(
        settings: RouteSettings(
          name: LoginUIEmailPasswordResetPassword.route,
        ),
        builder: (context) => LoginUIEmailPasswordResetPassword(
          loginSystem: widget.loginSystem,
          authRepository: widget.authRepository,
        ),
      ),
    );
    if (result is Map<String, dynamic>) {
      Navigator.of(context).pop(result);
    }
    setState(() => _loading = false);
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final emailPassword = widget.loginSystem.emailPassword();
        final result = await emailPassword.login(
          email: _email!,
          password: _password!,
        );
        await widget.authRepository.setToken(AuthToken(
          refresh: result.refresh,
          access: result.access,
        ));
        Navigator.of(context).pop(<String, dynamic>{
          'loggedIn': true,
          'registered': false,
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
