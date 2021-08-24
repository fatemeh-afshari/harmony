import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';

class LogFilterByErrorImpl extends AbstractLogFilter {
  final bool Function(Object? error) predicate;

  const LogFilterByErrorImpl(this.predicate);

  @override
  bool shouldLog(LogEvent event) => predicate(event.error);
}
