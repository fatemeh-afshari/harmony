# harmony_auth

Harmony Low-Level Authentication and Token Management Mechanism.

## Installation

add this library to your pubspec.yaml.

```yaml
dependencies:
  harmony_auth: latest.version
  # other libraries
  dio: 4.0.0
```

import harmony_auth.

```dart
import 'package:harmony_auth/harmony_auth.dart';
```

## Usage

The responsibility of harmony_auth is to manage tokon in order to authenticate users when accessing server
APIs. It also has ability to monitor or retreave authentication status of the user. It is designed with the
mindset of using `dio` as http library.

harmony_auth has many working blocks, but the two most important ones are a repository `AuthRepositry` and
an dio interceptor `AuthInterceptor`. Repository is where you save, edit, delete or refresh tokens. And it
also exposes API to retreave or monitor user authentication state. And interceptor is where we intercept each
dio request and add token to header (or any other manipulation). It also will refresh tokens when an unauthenticated
error is faced during interception. And finally if there is no way to authenticate user it will throw dio errors
downstream to make library user to send the user to login page.

You are mostly concerned about repository, as it is where you can manipulate tokens and get authentication state.
The interceptor is not used directly by the user as it is added to dio interceptors.
After creating all parts of auth system you only need to register repository and manipulated dio with dependency injection.

There is an `AuthToken` type to represent tokens which contain access and refresh tokens. You either have a
complete auth token pair or none of them. There is not case where you have a partial token.
When logging in you should set access and refresh tokens to repository and
when logging out you should remove token from repository.
Also if you have re-loggined user or you got an new token by any means you should update token on repository.
This is a rare case, but for example because of security reasons, you had need to refresh token, you can call
refresh on the repository. Most of the methods return Future so they should be awaited.
Make sure to read auth respoitory dart docs for any custom usage.

To get user authentication status you should add `streaming` capability to your auth storage when adding it to
auth repository. But after that you can access authentication status by using `status` getter on repository which will return
an enum with two possible logged in and logged out values. You can also get stream of authentication status
changes by using `statusStream` getter. If you need to get an initial state on status stream use `initializeStatusStream`
method on repository. If streaming capability is not added to storage these methods will throw errors when used.

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

[Simple Example](guide/simple.dart)

[Complex Example](guide/complex.dart)
