import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_fire/harmony_fire.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/widgets/loading_text_button.dart';

class LogoutButton extends StatefulWidget {
  final AuthRepository authRepository;
  final LoginSystem loginSystem;
  final FireSigning? fireSigning;

  final void Function() onSuccess;

  const LogoutButton({
    Key? key,
    required this.authRepository,
    required this.loginSystem,

    /// will be sign out from firebase if provided
    this.fireSigning,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return LoginUILoadingTextButton(
      title: 'Logout',
      loading: _loading,
      showLoading: true,
      onPressed: _onPressed,
    );
  }

  Future<void> _onPressed() async {
    setState(() => _loading = true);
    try {
      await widget.loginSystem.logout();
      await widget.fireSigning?.signOut();
      await widget.authRepository.removeToken();
      widget.onSuccess();
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A problem occurred')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
}
