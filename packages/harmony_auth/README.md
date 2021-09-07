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

The responsibility of harmony_auth is to manage token in order to authenticate users when accessing server APIs. It also
has ability to monitor or retrieve authentication status of the user. It is designed with the mindset of using `dio` as
http library.

harmony_auth has many working blocks, but the two most important ones are a repository `AuthRepositry` and a dio
interceptor `AuthInterceptor`. Repository is where you save, edit, delete or refresh tokens. And it also exposes API to
retrieve or monitor user authentication state. And interceptor is where we intercept each dio request and add token to
header (or any other manipulation). It also will refresh tokens when an unauthenticated error is faced during
interception. And finally if there is no way to authenticate user it will throw dio errors downstream to make library
user to send the user to login page.

You are mostly concerned about repository, as it is where you can manipulate tokens and get authentication state. The
interceptor is not used directly by the user as it is added to dio interceptors. After creating all parts of auth system
you only need to register repository and manipulated dio with dependency injection.

There is an `AuthToken` type to represent tokens which contain access and refresh tokens. You either have a complete
auth token pair or none of them. There is no case where you have a partial token. When logging in you should set access
and refresh tokens to repository and when logging out you should remove token from repository. Also if you have re-login
user, or you got an new token by any means you should update token on repository. This is a rare case, but for example
because of security reasons, you had needed to refresh token, you can call refresh on the repository. Most of the
methods return Future, so they should be awaited. Make sure to read auth repository dart docs for any custom usage.

To get user authentication status you should add `streaming` capability to your auth storage when adding it to auth
repository. But after that you can access authentication status by using `status` getter on repository which will return
an enum with two possible logged in and logged out values. You can also get stream of authentication status changes by
using `statusStream` getter. If you need to get an initial state on status stream use `initializeStatusStream`
method on repository. If streaming capability is not added to storage these methods will throw errors when used.

In usual usage harmony_auth by itself will not throw any errors. The only way errors is the usual way of errors being
thrown when calling http methods on dio. For example when you call `get` on dio you might get a `DioError` error in your
catch clause if you have used async/await or on your `catchErrors` method if you used Future without async/await. These
DioError objects has many fields. Two are `error` and `type`. The type will indicate the type of error, for
example `DioErrorType.response` will indicate a bad response code such as `500`. And the error will indicate the actual
thrown error internally, for example error will be of type SocketException when facing network problems. harmony_auth
through its interceptor will also throw some DioErrors. The most important one being when we face a not recoverable
unauthenticated error. So no tokens are available (in most cases), and you should redirect user to login page.
This `DioError` has type of `DioErrorType.other` and error of type `AuthException`. You can use `isAuthException`
extension method on `DioError` for convenience. There is one other type of error which will originate from this library,
but it will happen only in very rare scenarios.

## Usage Steps

- create a dio.
- create and add a logger if needed.
- create an auth storage.
- create an auth checker for rest.
- create an auth rest.
- create an auth repository by using storage and rest.
- create an auth matcher for interceptor.
- create an auth checker for interceptor.
- create an auth manipulator for interceptor.
- create an interceptor by using repository, matched, checker and manipulator.
- add interceptor to dio interceptors.
- register repository and dio with dependency injection.

## Complete Examples

[Simple Example](guide/simple.dart)

[Complex Example](guide/complex.dart)
