# harmony_auth

Harmony Low-Level Authentication and Token Management Mechanism

## Installation

Since this package is a private package and we have published it on a private server. you can't directly install it from pub.dev site.
to add this library to your project, add the following lines to your pubspec.yaml file:

```yaml
dependencies:
  harmony_auth:
    hosted:
      # this is your package name
      name: harmony_auth
      # your private server. change it if you want to use a different server
      url: https://unpub.cloud.6thsolution.tech
    version: latest.version
  # other libraries
  dio: 4.0.0
```

import harmony_auth.

```dart
import 'package:harmony_auth/harmony_auth.dart';
```

## Introduction

The responsibility of harmony_auth is to manage token in order to authenticate users when accessing server APIs. It also
has ability to monitor or retrieve authentication status of the user. It is designed with the mindset of using `dio` as
http library.

harmony_auth has many working blocks, but the two most important ones are a repository `AuthRepositry` and a dio
interceptor `AuthInterceptor`. Repository is where you save, edit, delete or refresh tokens. And it also exposes API to
retrieve or monitor user authentication state. And interceptor is where we intercept each dio request and add token to
header (or any other manipulation). It also will also refresh tokens and retry requests when an unauthenticated error is
faced during interception. And finally if there is no way to authenticate user it will throw dio errors downstream to
make library user to send the user to login page. In most cases when an error is sent downstream we have no token or
token is removed, because of being invalid.

You are mostly concerned about repository, as it is where you can manipulate tokens and get authentication state. The
interceptor is not used directly by the user as it is added to dio interceptors. After creating all parts of auth system
you only need to register repository and manipulated dio with dependency injection.

There is an `AuthToken` type to represent tokens which contain access and refresh tokens. You either have a complete
auth token pair or none of them. There is no case where you have a partial token. When logging in you should set access
and refresh tokens to repository and when logging out you should remove token from repository. Also if you have re-login
user, or you got an new token by any means you should update token on repository. This is a rare case, but for example
because of security reasons, you had needed to refresh token, you can call refresh on the repository. When refresh is
called on repository then it will refresh and replace token with new one, fail because of token being invalid which will
remove token and throw exception and face network problems which will throw DioErrors. Most of the methods return
Future, so they should be awaited. Make sure to read auth repository dart docs for any custom usage.

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

## Usage Steps Summary

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

## Usage Steps Details

First you need to create a dio object, and add whatever options you need to it. Only keep in mind that you should not
change dio properties in a way that it treats unauthenticated errors as successful.

```
final dio = Dio();
```

Then if you want to get logs from harmony_auth. Create a logger and add whatever options you need to it. Add this logger
to harmony_auth using:

```
final logger = Logger();
AuthConfig.logger = logger;
```

Then you should create an auth storage. It can be done using `AuthStorage` factories. The standard one creates a
shared_preferences based storage on android and ios and similar ones on other platforms. There is also an `inMemory`
implementation which is an in memory storage.

```
final storage = AuthStorage();
```

If you need to access to authentication status or authentication status stream, add `streaming` capability to your
storage. And If you do concurrent requests on dio, (and generally this is recommended), add `locked` capability to
storage.

```
storage = storage.streaming().locked();
```

Then you need to creat an auth rest. It can be created using `AuthRest` factories. Its first responsibility is to get a
token pair and do network request to refresh tokens and then return the new one. It can be successful which returns new
token, fail because of invalid token which will throw an exception of type `AuthRestException` or fail because of other
problems such as network problem which will throw exception of type `DioError`. It should not have any side effects. The
other responsibility is to return an auth matcher to match against the refresh request, as we use the same dio
throughout all of the harmony_auth parts. The standard implementation is when you send refresh token and get a new
refresh and access token pair from server. The `accessOnly` implementation is when the refresh token is constant and
only you get a new access token on refresh request. there is a `general` factory which you can use to create your custom
rest. please check out dart docs for custom usage. You should provide an auth checker with standard and access only
implementations which most of the times a simple `AuthChecker()` will suffice. Its responsibility is to check http
results to see if is about token being invalid. The standard one checks if response code is 401.

```
final rest = AuthRest(
  dio: dio,
  refreshUrl: refreshUrl,
  checker: AuthChecker(),
);
```

Then you need to create an auth repository by passing storage and rest to it. It has a single standard factory.

```
final repository = AuthRepository(
  storage: storage,
  rest: rest,
);
```

If you may have concurrent requests, (and generally this is recommended), add `locked`
capability to your repository. And also consider adding `debounce` capability which will limit number of refresh
requests in time. For example with 1 minute debouncing harmony_auth won't refresh tokens, if it has already refreshed
tokens in less than one minutes.

```
repository = repository.debounce(Duration(minutes: 1)).locked();
```

Then you should create an auth matcher for interceptor. `AuthMatcher` is used to match against requests to check if it
needs authentication. You should exactly match all requests that need authentication and don't match the ones that don't
need authentication, or you will face issues. Auth matcher has lots of factories:
`all` and `none` to match all and none of the requests. `url` and `urls` to match against urls which can be expressed
also by regex. `baseUrl` and `baseUrls` to match against starting part of urls. `byUrl` to give you complete control on
url. `method` and `methods` to match against methods which can be expressed also by regex. methods are always expressed
in upper case format like `GET`. `byMethod` to give you complete control over method. `methodAndUrl`, `methodAndBaseUrl`
and `byMethodAndUrl` like so. `general` to give you complete control over each request. All of matchers support standard
set operations like `|`, `&`, `_` and `!`.

```
final matcher = AuthMatcher.baseUrl(baseUrl) - 
  AuthMatcher.urls({
    '$baseUrl/ignored/1',
    '$baseUrl/ignored/2',
  });
```

Then you should create an auth checker for interceptor. `AuthChecker` responsibility is to check DioErrors to see if it
is related to unauthenticated or not. The standard one `AuthChecker` only checks if it is an error from response and its
code is 401. There are other factories for auth checker like `stausCode`, `stausCodes` and `byStatusCode` to have
complete control over status code. And `general` to have complete control over DioErrors.

```
final checker = AuthChecker();
```

Then you should create an auth manipulator for interceptor. `AuthMaipulator` responsibility is to manipulate dio
requests in place by using the given auth token. The standard one `AuthManipulator()`
adds `Authorization: Bearer $accessToken` to request headers. There are factories like `headers` to add multiple
headers, `header` to add one header, `headerPrefixed` to add a header with value being access token prefixed with some
given string. And `general` which gives you complete control.

```
final manipulator = AuthManipulator();
```

Then you need to create an interceptor which is done by using its standard factory `AuthInterceptor()`.

```
final interceptor = AuthInterceptor(
  dio: dio,
  matcher: matcher,
  checker: checker,
  manipulator: manipulator,
  repository: repository,
);
```

Then you need to add interceptor to dio interceptors:

```
dio.interceptors.add(interceptor);
```

Then you need to register dio and repository with dependency injection.

**NOTE:** that you should use the same dio throughout the entire harmony_auth library.

## Complete Examples

[Simple Example](guide/simple.dart)

[Complex Example](guide/complex.dart)
