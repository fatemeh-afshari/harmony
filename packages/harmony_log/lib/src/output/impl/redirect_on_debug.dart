import 'package:flutter/foundation.dart';
import 'package:harmony_log/src/output/impl/redirect.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogOutputRedirectOnDebugImpl extends LogOutputRedirectImpl {
  const LogOutputRedirectOnDebugImpl({
    required LogOutput child,
  }) : super(
          enabled: kDebugMode,
          child: child,
        );
}
