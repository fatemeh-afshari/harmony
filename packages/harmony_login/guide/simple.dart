import 'package:dio/dio.dart';
import 'package:harmony_login/harmony_login.dart';

Future<void> main() async {
  final dio = Dio(/*...*/);

  // then register dio with harmony_auth.
  print(dio);

  // create a login system:
  final system = LoginSystem(
    baseUrl: 'https://site.com/api',
    dio: dio,
  );

  // register login system with dependency injection:
  print(system);

  // email-password:
  final emailPassword = system.emailPassword();
  // login
  final result1 = await emailPassword.login(
    email: 'a@b.com',
    password: '123456',
  );
  // add register result with harmony_auth
  print(result1);

  // social:
  final social = system.social();
  // login using harmony_fire and then:
  final result2 = await social.login(
    provider: 'google',
    email: 'a@b.com',
  );
  // add register result with harmony_auth
  print(result2);

  // logout:
  await system.logout();
}
