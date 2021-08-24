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

If you want to check logged in state use `status` extension method on storage.

If you want a stream of login and logout events consider using `wrapWithStatus` and
`statusStream` extension methods on storage.

## Errors

The only type of error from harmony_auth is `DioError` with type of `DioErrorType.other` and error of
type `AuthException`.

You can use `isAuthException`, `asAuthException` and other extension methods on `DioError` for convenience.

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
- create an auth repository.
- create and add interceptor.

[Simple Example](example/simple.dart)

[Complex Example](example/complex.dart)
