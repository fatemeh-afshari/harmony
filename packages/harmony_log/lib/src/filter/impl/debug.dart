import 'package:flutter/foundation.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';

class LogFilterDebugImpl extends AbstractLogFilter {
  const LogFilterDebugImpl();

  @override
  bool shouldLog(LogEvent event) => kDebugMode;
}
