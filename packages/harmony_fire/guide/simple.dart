import 'package:harmony_fire/harmony_fire.dart';
import 'package:harmony_log/harmony_log.dart';

Future<void> main() async {
  FireConfig.log = _buildLog();

  // create a signing:
  final signing = FireSigning();

  // you should register signing with dependency injection:
  print(signing);

  // check if is signed in or not:
  final isSignedIn = signing.isSignedIn();
  print(isSignedIn);

  // anonymously sign in to firebase:
  await signing.signInUpAnonymously();

  // social sign in to firebase:
  // first you need a provider:
  final provider = signing.providerOf('google');
  // then check if is available specially for apple:
  await provider.isAvailable;
  // then
  final info = await signing.signInUpSocial(provider);
  print(info.email);
  print(info.uid);
  print(info.displayName);
  // it can throw FireCancelledException on cancelled.
  // and firebase exceptions on other scenarios.

  // sign out:
  await signing.signOut();
}

/// build a logger ...
Log _buildLog() => Log(
      id: LogId(),
      output: LogOutput.redirectOnDebug(
        child: LogOutput.plain(
          format: LogPlainFormat.simple(),
          child: LogPlainOutput.console(),
        ),
      ),
    );
