import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';

class LogFilterExtraImpl extends AbstractLogFilter {
  final Object? extra;

  const LogFilterExtraImpl(this.extra);

  @override
  bool shouldLog(LogEvent event) => event.extra == extra;
}
