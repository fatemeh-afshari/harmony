import 'package:dio/dio.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_log/harmony_log.dart';

const baseUrl = 'https://base/';
const refreshUrl = '${baseUrl}user/token/refresh/';

Future<void> init() async {
  AuthConfig.log = _buildLog();

  final dio = Dio(/*...*/);
  final repository = AuthRepository(
    storage: AuthStorage().streaming().locked(),
    rest: AuthRest(
      dio: dio,
      refreshUrl: refreshUrl,
      checker: AuthChecker(),
    ),
  ).debounce(Duration(minutes: 1)).locked();
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
