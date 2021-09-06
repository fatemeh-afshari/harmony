import 'package:flutter/foundation.dart';
import 'package:harmony_log/src/output/impl/redirect.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogOutputRedirectOnReleaseImpl extends LogOutputRedirectImpl {
  const LogOutputRedirectOnReleaseImpl({
    required LogOutput child,
  }) : super(
          enabled: kReleaseMode,
          child: child,
        );
}
