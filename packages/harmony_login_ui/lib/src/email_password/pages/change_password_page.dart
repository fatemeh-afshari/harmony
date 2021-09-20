import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/widgets/loading_elevated_button.dart';
import 'package:harmony_login_ui/src/widgets/password_form_field.dart';
import 'package:harmony_login_ui/src/widgets/password_pair_form_field.dart';

class LoginUIEmailPasswordChangePassword extends StatefulWidget {
  static const route = '/harmony_login_ui/email_password/change_password/';

  final AuthRepository authRepository;
  final LoginSystem loginSystem;

  const LoginUIEmailPasswordChangePassword({
    Key? key,
    required this.authRepository,
    required this.loginSystem,
  }) : super(key: key);

  @override
  _LoginUIEmailPasswordChangePasswordState createState() =>
      _LoginUIEmailPasswordChangePasswordState();
}

class _LoginUIEmailPasswordChangePasswordState
    extends State<LoginUIEmailPasswordChangePassword> {
  final _formKey = GlobalKey<FormState>();

  var _loading = false;

  String? _oldPassword;
  String? _newPassword;

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
                LoginUIPasswordFromField(
                  passwordHint: 'Old Password',
                  hasNext: true,
                  onSaved: (value) => _oldPassword = value,
                ),
                const SizedBox(height: 32),
                LoginUIPasswordPairFromField(
                  passwordHint: 'New Password',
                  confirmHint: 'Confirm New Password',
                  onSaved: (value) => _newPassword = value,
                ),
                const Spacer(),
                LoginUILoadingElevatedButton(
                  title: 'Change Password',
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
        final emailPassword = widget.loginSystem.emailPassword();
        await emailPassword.changePassword(
          oldPassword: _oldPassword!,
          newPassword: _newPassword!,
        );
        Navigator.of(context).pop(<String, dynamic>{
          'password_changed': true,
        });
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
