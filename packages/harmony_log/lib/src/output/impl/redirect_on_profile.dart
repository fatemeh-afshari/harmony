import 'package:flutter/foundation.dart';
import 'package:harmony_log/src/output/impl/redirect.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogOutputRedirectOnProfileImpl extends LogOutputRedirectImpl {
  const LogOutputRedirectOnProfileImpl({
    required LogOutput child,
  }) : super(
          enabled: kProfileMode,
          child: child,
        );
}
