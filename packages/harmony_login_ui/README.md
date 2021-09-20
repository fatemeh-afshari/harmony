# harmony_login

Harmony Login UI Elements

## Installation

add this library to your pubspec.yaml.

```yaml
dependencies:
  harmony_login_ui: latest.version
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
