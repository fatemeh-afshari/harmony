import 'package:dio/dio.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:logger/logger.dart';

void main() async {
  // create and set logger:
  final logger = Logger(/*...*/);
  Auth.logger = logger;

  // create storage:
  final storage = AuthStorage().wrapWithLock().wrapWithStatus();

  // register with injection storage ...
  print(storage);

  // create dio:
  final dio = Dio(/*...*/);

  // your base url:
  const baseUrl = 'https://base/';

  // create and set interceptor:
  final checker = AuthChecker();
  final rest = AuthRest(
    dio: dio,
    refreshUrl: '${baseUrl}user/token/refresh/',
    checker: checker,
  );
  final refresh = AuthRefresh(
    storage: storage,
    rest: rest,
  ).wrapWithLock();
  final matcher = AuthMatcher.baseUrl(baseUrl);
  final manipulator = AuthManipulator();
  final interceptor = AuthInterceptor(
    dio: dio,
    storage: storage,
    matcher: matcher,
    checker: checker,
    rest: rest,
    manipulator: manipulator,
    refresh: refresh,
  );
  dio.interceptors.add(interceptor);

  // register with injection dio ...
  print(storage);
}
