import 'package:dio/dio.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:logger/logger.dart';

const baseUrl = 'https://base/';

void init() async {
  // logger:
  // to add logger:
  final logger = Logger(/*...*/);
  Auth.logger = logger;
  // to clear logger:
  Auth.logger = null;

  // storage:
  // standard storage, persisted using shared_preferences.
  // it also supports flutter web.
  var storage = AuthStorage();
  // or use in memory implementation.
  AuthStorage.inMemory();
  // or subclass AuthStorage by yourself for other scenarios.

  // if you want to enable concurrency:
  storage = storage.locked();
  // this way operations on storage can be concurrent.

  // you can get authentication status by using:
  await storage.status;

  // if you want to listen status changes stream:
  storage = storage.streaming();
  // then you can use:
  final stream = storage.statusStream;
  stream.listen(print);
  // or
  storage.statusStreamOrNull;
  // which will be null if storage is not wrapped.
  // and you can initialize stream by initial value if needed.
  await storage.initializeStatusStreamOrNothing();
  // and
  await storage.initializeStatusStream();

  // now you can register storage with dependency injection:
  print(storage);

  // dio:
  final dio = Dio();
  // you can apply all sorts of configurations to your dio
  // like adding loggers, setting baseUrl and ...
  // you should register dio with dependency injection
  //  after adding auth interceptor to it.

  // matcher:
  // example
  final matcher = AuthMatcher.baseUrl(baseUrl) -
      AuthMatcher.baseUrl('https://other_base/') -
      AuthMatcher.baseUrl('${baseUrl}ignored_1/') -
      AuthMatcher.methodAndUrl('GET', '${baseUrl}ignored_2/');
  // you can use set operators on matchers.
  // m1 | m2
  // m1 - m2
  // m1 ^ m2
  // m1 & m2
  // !m1
  // or match all urls
  AuthMatcher.all();
  // or match none of urls
  AuthMatcher.none();
  // or other matchers:
  AuthMatcher.url('https://base/url/');
  AuthMatcher.urls({'https://base/url1/', 'https://base/url2/'});
  AuthMatcher.baseUrl('https://base/');
  AuthMatcher.baseUrls({'https://base1/', 'https://base2/'});
  AuthMatcher.method('GET');
  AuthMatcher.methods({'GET', 'POST'});
  AuthMatcher.byUrl((url) => false);
  AuthMatcher.byMethod((method) => false);
  AuthMatcher.methodAndUrl('GET', 'https://base/url/');
  AuthMatcher.methodAndBaseUrl('GET', 'https://base/');
  AuthMatcher.byMethodAndUrl((method, url) => false);
  // or check docs for other types of matchers.
  // you can almost match anything without the need for sub-classing AuthMatcher.
  // for very complex scenarios you can use
  //  AuthMatcher.general or sub-class AuthMatcher by yourself.
  AuthMatcher.general((request) => false);

  // checker:
  final checker = AuthChecker();
  // this is to check which dio errors are because of unauthorized call.
  // there are other checkers based on status code
  AuthChecker.statusCode(401);
  AuthChecker.statusCodes({401, 402});
  AuthChecker.byStatusCode((statusCode) => false);
  // and ...
  // you can subclass AuthChecker your self if you need better control or
  //  use AuthChecker.general.
  AuthChecker.general((error) => false);
  // also keep in mind that, non-matched requests are not
  //  checked for unauthorized responses.
  // note: you can use different checkers for interceptor and rest,
  //  but it is not needed most of the time.

  // rest:
  var rest = AuthRest(
    dio: dio,
    refreshUrl: '${baseUrl}api/user/token/refresh/',
    checker: checker,
  );
  // or use accessOnly implementation if refresh request only
  //  responses with access token.
  AuthRest.accessOnly(
    dio: dio,
    refreshUrl: '${baseUrl}api/user/token/refresh/',
    checker: checker,
  );
  // or subclass AuthRest by yourself or use AuthRest.general
  //  for complex cases.
  AuthRest.general(
    dio: dio,
    refreshTokensMatcher: AuthMatcher.methodAndUrl(
      'POST',
      '${baseUrl}api/user/token/refresh/',
    ),
    refresh: (dio, refresh) => throw 'implement this',
  );
  // if you decided to subclass [AuthRest] by your self
  //  or using AuthRest.general,
  //  make sure that your refresh operation does not have any
  //  side effects and also please only throw [AuthException]
  //  when token is invalidated and for other types of
  //  errors (like socket exception) only throw [DioError]s.
  // please check docs for further details.

  // manipulator:
  final manipulator = AuthManipulator();
  // standard manipulator adds `authorization: Bearer $accessToken`
  //  to request header.
  // there are several different implementations:
  AuthManipulator.headerPrefixed('authorization', 'Bearer ');
  AuthManipulator.header('authorization', (access) => 'Bearer $access');
  AuthManipulator.headers((access) => {
        'authorization': 'Bearer $access',
        'token': access,
      });
  AuthManipulator.general((request, access) => throw 'implement this');
  // and you can sub-class AuthManipulator by yourself or
  // use AuthManipulator.general for complex cases.

  // repository:
  var repository = AuthRepository(
    storage: storage,
    rest: rest,
  );
  // this is used to guard against rest and storage calls.

  // if you want to debounce refresh calls:
  repository = repository.debounce(Duration(minutes: 1));

  // if you want to add concurrency support to repository:
  repository = repository.locked();

  // interceptor:
  final interceptor = AuthInterceptor(
    dio: dio,
    matcher: matcher,
    checker: checker,
    manipulator: manipulator,
    repository: repository,
  );
  // this is the main building block of auth module.

  // and add it to your dio
  dio.interceptors.add(interceptor);

  // now you can register dio with dependency injection.
  print(dio);
}
