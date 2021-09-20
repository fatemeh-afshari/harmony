# harmony_login

Harmony Login Mechanism

## Installation

add this library to your pubspec.yaml.

```yaml
dependencies:
  harmony_login: latest.version
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
