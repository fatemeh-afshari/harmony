import 'package:dio/dio.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:logger/logger.dart';

const baseUrl = 'https://base/';
const refreshUrl = '${baseUrl}user/token/refresh/';

void init() async {
  Auth.logger = Logger(/*...*/);

  final dio = Dio(/*...*/);
  final repository = AuthRepository(
    storage: AuthStorage().wrapWithLock().wrapWithStatus(),
    rest: AuthRest(
      dio: dio,
      refreshUrl: refreshUrl,
      checker: AuthChecker(),
    ),
  ).wrapWithLock();
  final interceptor = AuthInterceptor(
    dio: dio,
    matcher: AuthMatcher.baseUrl(baseUrl),
    checker: AuthChecker(),
    manipulator: AuthManipulator(),
    repository: repository,
  );
  dio.interceptors.add(interceptor);

  // register with injection dio ...
  print(repository);
  print(dio);
}
