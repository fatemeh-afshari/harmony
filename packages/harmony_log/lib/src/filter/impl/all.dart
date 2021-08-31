import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';
import 'package:meta/meta.dart';

@internal
class LogFilterAllImpl extends AbstractLogFilter {
  const LogFilterAllImpl();

  @override
  bool shouldLog(LogEvent event) => true;
}
