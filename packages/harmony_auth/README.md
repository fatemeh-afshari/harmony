# harmony_auth

Harmony Low-Level Authentication/Authorization Mechanism.

## Installation

add this library to your pubspec.yaml.

```yaml
dependencies:
  harmony_auth: latest.version
  # other libraries
  logger: 1.0.0
  dio: 4.0.0
```

import harmony_auth.

```dart
import 'package:harmony_auth/harmony_auth.dart';
```

## Tokens

When logging in you should set access and refresh tokens to storage.

When logging out you should clear storage.

If you want to check logged in state use isLoggedIn extension method on storage.

## Errors

The only type of error from harmony_auth is DioError with type of DioErrorType.other and error of type AuthException.

You can use isAuthException, asAuthException and asAuthExceptionOrNull extension methods on DioError for convenience.

When auth exception occurs it means that no tokens are present and user is logged out. so you should make user log in
again.

## Usage

- create and add a logger if needed.
- create an auth storage.
- create a dio.
- create an auth matcher.
- create an auth checker.
- create an auth rest.
- create an auth manipulator.
- create and add interceptor.

for example:

```dart
void init() {
  // to add a logger:
  final logger = Logger(/*...*/);
  Auth.logger = logger;
  // to clear logger:
  Auth.logger = null;

  // storage:
  var storage = AuthStorage.standard();
  // standard will be using shared preferences and is persisted
  // or use in memory implementation
  AuthStorage.inMemory();
  // or subclass AuthStorage by yourself for other scenarios
  // you should register storage with dependency injection

  // you can get authentication status by using:
  // await storage.status;

  // if you want to listen status changes stream:
  storage = storage.wrapWithStatus();
  // then you can use:
  storage.statusStream;
  // or
  storage.statusStreamOrNull;
  // which will be null if storage is not wrapped.
  // and you can initialize stream by initial value if needed.
  // await storage.initializeStatusStreamOrNothing();
  // and
  // await storage.initializeStatusStream();

  // dio:
  final dio = Dio();
  // you can apply all sorts of configurations to your dio
  // like adding loggers, setting baseUrl and ...
  // you should register dio with dependency injection
  //  after adding auth interceptor to it.

  // matcher:
  // example
  final matcher = AuthMatcher.baseUrl('https://base.com/api/') +
      AuthMatcher.baseUrl('https://other_base.com/api/') -
      AuthMatcher.baseUrl('https://base.com/api/ignored/') -
      (AuthMatcher.url('https://base.com/api/exception/') & AuthMatcher.method('GET'));
  // you can use most of set operation on matchers
  // or match all urls
  AuthMatcher.all();
  // or match none of urls
  AuthMatcher.none();
  // or check docs for other types of matchers
  // you can almost match anything without the need for sub-classing AuthMatcher
  // for very complex scenarios there is [AuthMatcherBase] class
  //  which can be implemented to have request level control.

  // checker:
  final checker = AuthChecker.standard();
  // this is to check which dio errors are because of unauthorized call.
  // there are other checkers based on status code
  AuthChecker.statusCode(401);
  AuthChecker.statusCodes({401, 402});
  // and ...
  // you can subclass AuthChecker your self if you need better control.
  // also keep in mind that, non-matched requests are not
  //  checked for unauthorized responses.
  // note: you can use different checkers for interceptor and rest,
  //  but it is not needed most of the time.

  // rest:
  final rest = AuthRest.standard(
    dio: dio,
    refreshUrl: 'https://base.com/api/user/token/refresh/',
    checker: checker,
  );
  // or use accessOnly implementation if refresh request only
  //  responses with access token
  AuthRest.accessOnly(/* ... */);
  // or subclass AuthRest by yourself or use AuthRest.general
  //  for complex cases.
  // if you decided to subclass [AuthRest] by your self
  //  or using AuthRest.general,
  //  make sure that your refresh operation does not have any
  //  side effects and also please only throw [DioError]s from
  //  refresh method and if refresh token is invalid, throw dio error
  //  with type of other and error of type AuthException. there
  //  is AuthException().toDioError( ... ) extension method to help
  //  you.
  // please check docs for further details

  // manipulator:
  final manipulator = AuthManipulator.standard();
  // standard manipulator adds `authorization: Bearer accessToken`
  //  to request header.
  // there are several different implementations:
  AuthManipulator.headerPrefix('key', 'prefix');
  AuthManipulator.header(/*...*/);
  AuthManipulator.headers(/*...*/);
  AuthManipulator.general(/*...*/);
  // and you can sub-class AuthManipulator by yourself or
  // use AuthManipulator.general for complex cases.

  // interceptor:
  final interceptor = AuthInterceptor.standard(
    dio: dio,
    storage: storage,
    matcher: matcher,
    checker: checker,
    rest: rest,
    manipulator: manipuator,
  );
  // and add it to your dio
  dio.interceptors.add(interceptor);

  // now you can register dio with dependency injection.
}
```

## TODO

calls which response is not JSON.
