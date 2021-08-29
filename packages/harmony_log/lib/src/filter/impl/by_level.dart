import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:meta/meta.dart';

@internal
class LogFilterByLevelImpl extends AbstractLogFilter {
  final bool Function(LogLevel level) predicate;

  const LogFilterByLevelImpl(this.predicate);

  @override
  bool shouldLog(LogEvent event) => predicate(event.level);
}
