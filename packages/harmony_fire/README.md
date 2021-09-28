# harmony_fire

Harmony Firebase and Social Login Mechanism

## Installation

Since this package is a private package and we have published it on a private server. you can't directly install it from pub.dev site.
to add this library to your project, add the following lines to your pubspec.yaml file:

```yaml
dependencies:
  harmony_fire:
    hosted:
      # this is your package name
      name: harmony_fire
      # your private server. change it if you want to use a different server
      url: https://unpub.cloud.6thsolution.tech
    version: latest.version
```

import harmony_log.

```dart
import 'package:harmony_fire/harmony_fire.dart';
```

## Perquisite

First you need to configure the following:

- firebase
- google sign in
- facebook sign in
- apple sign in
- firebase auth for google, apple and facebook

## Introduction

`harmony_fire` responsibility is to manage a firebase user and authenticate them using oauth providers like google,
facebook and apple. It supports Android, IOS and Web.

## Usage

If you want to get logs from harmony_fire, create a logger and add whatever options you need to it. Add this logger to
harmony_fire using:

```
final logger = Logger();
FireConfig.logger = logger;
```

First you need to create `FireSigning`:

```
final signing = FireSigning();
```

Then you can check signed in state using `isSignedIn` method:

```
final isSignedIn = signing.isSignedIn();
```

You can sign in/up anonymously using `signInUpAnonymously` method:

```
await signing.signInUpAnonymously();
```

If is already signed in anonymously it will not do any thing. If is of other kind it will sign out first.

You can sign in/up with social accounts using `signInUpSocial`. First you need a provider which can be created
using `FireProcider` factories or `of` method.

```
final provider = signing.providerOf('google');
final info = await signing.signInUpSocial(provider);
```

If is signed in, it will sign out first. `info` contains information about signed in user like `uid`, `email` and
possibly a `displayName` which can be used to authenticate in server. it can throw `FireCancelledException` on
cancelled. And firebase exceptions on other scenarios.

You can sign out using:

```
await signing.signOut();
```

## Complete Examples

[Simple Example](guide/simple.dart)
