// import 'package:flutter/material.dart';
//
// class LoginUIEmailPasswordResetPassword extends StatefulWidget {
//   static const route = '/harmony_login_ui/email_password/reset_password';
//
//   const LoginUIEmailPasswordResetPassword({Key? key}) : super(key: key);
//
//   @override
//   _LoginUIEmailPasswordResetPasswordState createState() => _LoginUIEmailPasswordResetPasswordState();
// }
//
// class _LoginUIEmailPasswordResetPasswordState extends State<LoginUIEmailPasswordResetPassword> {
//   var _loading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: Form(
//           child: Padding(
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextFormField(
//                   autofillHints: const ['email'],
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     hintText: 'Email',
//                   ),
//                 ),
//                 const Spacer(),
//                 ElevatedButton(
//                   onPressed: _loading ? null : _resetPassword,
//                   child: _loading
//                       ? const LinearProgressIndicator()
//                       : const Text('Reset Password'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _resetPassword() async {
//     setState(() => _loading = true);
//     await Future<void>.delayed(const Duration(seconds: 1));
//     setState(() => _loading = false);
//   }
// }
