# harmony_auth

Harmony Low-Level Authentication/Authorization Mechanism.

## Installation and Usage

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

- create a dio.
- create a logger.
- create an auth matcher.
- create an auth builder.
- get storage for external token manipulation.
- get interceptor and add it to your dio interceptors.

for example:

```dart
void init() {
  final logger = Logger();
  final matcher =
      AuthMatcher.baseUrl('https://base.com/api/') +
          AuthMatcher.baseUrl('https://other_base.com/api/') -
          AuthMatcher.baseUrl('https://base.com/api/ignored/') -
          (AuthMatcher.url('https://base.com/api/exception/') & AuthMatcher.method('GET'));
  final builder = AuthBuilder(
    dio: dio,
    logger: logger,
    refreshUrl: 'https://base.com/api/user/token/refresh/',
    matcher: matcher,
  );
  final storage = builder.storage;

  final dio = Dio();
  builder.applyTo(dio);

  // then register with injection: dio and storage
}
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