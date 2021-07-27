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
  final dio = Dio();
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
  final interceptor = builder.interceptor;
  dio.interceptors.add(interceptor);
  // then register with injection: dio and storage
}
```
