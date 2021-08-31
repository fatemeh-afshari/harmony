import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';
import 'package:meta/meta.dart';

@internal
class LogFilterByTagImpl extends AbstractLogFilter {
  final bool Function(String? tag) predicate;

  const LogFilterByTagImpl(this.predicate);

  @override
  bool shouldLog(LogEvent event) => predicate(event.tag);
}
