import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';
import 'package:harmony_log/src/level/level.dart';

class LogFilterLevelImpl extends AbstractLogFilter {
  final LogLevel level;

  const LogFilterLevelImpl(this.level);

  @override
  bool shouldLog(LogEvent event) => event.level >= level;
}
