// import 'package:flutter/material.dart';
//
// class LoginUIChangePassword extends StatefulWidget {
//   static const route = '/harmony_login_ui/email_password/change_password';
//
//   const LoginUIChangePassword({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _LoginUIChangePasswordState createState() => _LoginUIChangePasswordState();
// }
//
// class _LoginUIChangePasswordState extends State<LoginUIChangePassword> {
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
//                   autofillHints: const ['password'],
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: const InputDecoration(
//                     hintText: 'Old Password',
//                   ),
//                 ),
//                 const SizedBox(height: 64),
//                 TextFormField(
//                   autofillHints: const ['password'],
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: const InputDecoration(
//                     hintText: 'New Password',
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 TextFormField(
//                   autofillHints: const ['password'],
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: const InputDecoration(
//                     hintText: 'Confirm New Password',
//                   ),
//                 ),
//                 const Spacer(),
//                 ElevatedButton(
//                   onPressed: _loading ? null : _changePassword,
//                   child: _loading
//                       ? const LinearProgressIndicator()
//                       : const Text('Change Password'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _changePassword() async {
//     setState(() => _loading = true);
//     await Future<void>.delayed(const Duration(seconds: 1));
//     setState(() => _loading = false);
//   }
// }
