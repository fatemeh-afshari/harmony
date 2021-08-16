import 'package:dio/dio.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:logger/logger.dart';

void main() async {
  final logger = Logger(/*...*/);
  Auth.logger = logger;
  final storage = AuthStorage().wrapWithStatus();
  final dio = Dio(/*...*/);
  final interceptor = AuthInterceptor(
    dio: dio,
    storage: storage,
    matcher: AuthMatcher.baseUrl('https://base/'),
    checker: AuthChecker(),
    rest: AuthRest(
      dio: dio,
      refreshUrl: 'https://base/user/token/refresh/',
      checker: AuthChecker(),
    ),
    manipulator: AuthManipulator(),
  );
  dio.interceptors.add(interceptor);

  // register with injection storage and dio ...
  print(storage);
  print(dio);
}
