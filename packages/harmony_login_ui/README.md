# harmony_login

Harmony Login UI Elements

## Installation

Since this package is a private package and we have published it on a private server. you can't directly install it from pub.dev site.
to add this library to your project, add the following lines to your pubspec.yaml file:

```yaml
dependencies:
  harmony_login_ui:
    hosted:
      # this is your package name
      name: harmony_login_ui
      # your private server. change it if you want to use a different server
      url: https://unpub.cloud.6thsolution.tech
    version: latest.version
```

import harmony_log.

```dart
import 'package:harmony_login_ui/harmony_login_ui.dart';
```

## Perquisite

First you need to configure:

- harmony_auth
- harmony_fire
- harmony_login

## Introduction

`harmony_login_ui` is here to make implementation of login process a lot easier. By adding some buttons on flutter your
login process is handled.

## Usage

To login/register/reset-password using email_password you can add this button on your UI:

```
EmailPasswordLoginButton(
    authRepository: authRepository,
    loginSystem: loginSystem,
    onSuccess: (String provider, String email, bool isRegistered) {
      // ...
    },
)
```

To login/register using social accounts you can use:

```
SocialLoginButton.google(
    authRepository: authRepository,
    loginSystem: loginSystem,
    fireSigning: fireSigning,
    onSuccess: (provider, email, displayName) {
      // ...
    },
)
```

It is available also for `facebook` and `apple`.

To logout you can add this:

```
LogoutButton(
    authRepository: authRepository,
    loginSystem: loginSystem,
    onSuccess: () {
      // ...
    },
)
```

And if you have signed in using email and password. You can add this button to change password:

```
ChangePasswordButton(
    authRepository: authRepository,
    loginSystem: loginSystem,
    onSuccess: () {
      // ...
    },
)
```

## Complete Examples

[Simple Example](guide/simple.dart)
