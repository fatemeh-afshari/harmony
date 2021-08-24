import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';

class LogFilterNoneImpl extends AbstractLogFilter {
  const LogFilterNoneImpl();

  @override
  bool shouldLog(LogEvent event) => false;
}
