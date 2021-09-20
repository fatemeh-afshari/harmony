import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/email_password/pages/reset_password_new_password_page.dart';
import 'package:harmony_login_ui/src/widgets/code_form_field.dart';
import 'package:harmony_login_ui/src/widgets/loading_elevated_button.dart';

class LoginUIEmailPasswordResetPasswordVerifyCode extends StatefulWidget {
  static const route =
      '/harmony_login_ui/email_password/login/reset_password/verify_code/';

  final AuthRepository authRepository;
  final LoginSystem loginSystem;
  final String email;

  const LoginUIEmailPasswordResetPasswordVerifyCode({
    Key? key,
    required this.authRepository,
    required this.loginSystem,
    required this.email,
  }) : super(key: key);

  @override
  _LoginUIEmailPasswordResetPasswordVerifyCodeState createState() =>
      _LoginUIEmailPasswordResetPasswordVerifyCodeState();
}

class _LoginUIEmailPasswordResetPasswordVerifyCodeState
    extends State<LoginUIEmailPasswordResetPasswordVerifyCode> {
  final _formKey = GlobalKey<FormState>();

  var _loading = false;

  String? _code;

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
                Center(
                  child: LoginUICodeFormField(
                    onSaved: (value) => _code = value,
                    hasNext: false,
                    onSubmit: _submit,
                    enabled: !_loading,
                  ),
                ),
                const Spacer(),
                LoginUILoadingElevatedButton(
                  title: 'Submit',
                  loading: _loading,
                  showLoading: true,
                  onPressed: _submit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final code = _code!;
        final emailPassword = widget.loginSystem.emailPassword();
        await emailPassword.resetPasswordVerifyCode(
          email: widget.email,
          code: code,
        );
        final result = await Navigator.of(context).push(
          MaterialPageRoute<Object?>(
            settings: const RouteSettings(
              name: LoginUIEmailPasswordResetPasswordNewPassword.route,
            ),
            builder: (context) => LoginUIEmailPasswordResetPasswordNewPassword(
              loginSystem: widget.loginSystem,
              authRepository: widget.authRepository,
              email: widget.email,
              code: code,
            ),
          ),
        );
        if (result is Map<String, dynamic>) {
          assert(result['password_reset'] == true);
          Navigator.of(context).pop(result);
        } else {
          Navigator.of(context).pop();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form has problems')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A problem occurred')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
}
