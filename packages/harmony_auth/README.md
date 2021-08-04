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
- create an auth rest.
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
  final storage = AuthStorage.standard();
  // standard will be using shared preferences and is persisted
  // or use in memory implementation
  AuthStorage.inMemory();
  // or subclass AuthStorage by yourself for other scenarios
  // you should register storage with dependency injection

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

  // rest:
  final rest = AuthRest.standard(
    dio: dio,
    refreshUrl: 'https://base.com/api/user/token/refresh/',
  );
  // or use accessOnly implementation if refresh request only
  //  responses with access token
  AuthRest.accessOnly(/* ... */);
  // or subclass AuthRest by yourself
  // please check docs for further details

  // interceptor:
  final interceptor = AuthInterceptor.standard(
    dio: dio,
    storage: storage,
    matcher: matcher,
    rest: rest,
  );
  // and add it to your dio
  dio.interceptors.add(interceptor);

  // now you can register dio with dependency injection.
}
```