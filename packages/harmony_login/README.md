# harmony_login

Harmony Login Mechanism

## Installation

Since this package is a private package and we have published it on a private server. you can't directly install it from pub.dev site.
to add this library to your project, add the following lines to your pubspec.yaml file:

```yaml
dependencies:
  harmony_login:
    hosted:
      # this is your package name
      name: harmony_login
      # your private server. change it if you want to use a different server
      url: https://unpub.cloud.6thsolution.tech
    version: latest.version
```

import harmony_log.

```dart
import 'package:harmony_login/harmony_login.dart';
```

## Perquisite

First you need to configure harmony_auth and harmony_fire.

## Introduction

`harmony_login` responsibility is to manage authentication by communicating with server.

## Usage

First you need a `dio` which is configured with `harmony_auth`:

```
final dio = Dio(/*...*/);
```

Then you should build a login system:

```
final system = LoginSystem(
    baseUrl: 'https://site.com/api',
    dio: dio,
  );
```

And you should register system with dependency injection.

Then you can use different backends, like `email_password`. And do any operation such as `login`, `regsiter` and ... on
them:

```
final emailPassword = system.emailPassword();
final result1 = await emailPassword.login(
    email: 'a@b.com',
    password: '123456',
);
```

And for social backend, first you need to sign in using harmony_fire and then:

```
final social = system.social();
final result2 = await social.login(
    provider: 'google',
    email: 'a@b.com',
);
```

At last you can sign out using `logout`:

```
await system.logout();
```

## Complete Examples

[Simple Example](guide/simple.dart)
