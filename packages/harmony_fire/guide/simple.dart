import 'package:harmony_fire/harmony_fire.dart';
import 'package:logger/logger.dart';

Future<void> main() async {
  FireConfig.logger = Logger(/*...*/);

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
