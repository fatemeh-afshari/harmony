import 'package:flutter/foundation.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';

class LogFilterProfileImpl extends AbstractLogFilter {
  const LogFilterProfileImpl();

  @override
  bool shouldLog(LogEvent event) => kProfileMode;
}
