import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';
import 'package:meta/meta.dart';

@internal
class LogFilterByMessageImpl extends AbstractLogFilter {
  final bool Function(String message) predicate;

  const LogFilterByMessageImpl(this.predicate);

  @override
  bool shouldLog(LogEvent event) => predicate(event.message);
}
