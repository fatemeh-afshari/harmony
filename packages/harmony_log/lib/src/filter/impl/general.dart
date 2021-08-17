import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';

class LogFilterGeneralImpl extends AbstractLogFilter {
  final bool Function(LogEvent event) predicate;

  const LogFilterGeneralImpl(this.predicate);

  @override
  bool shouldLog(LogEvent event) => predicate(event);
}
