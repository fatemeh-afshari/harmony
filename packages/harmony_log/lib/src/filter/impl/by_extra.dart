import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';
import 'package:meta/meta.dart';

@internal
class LogFilterByExtraImpl extends AbstractLogFilter {
  final bool Function(Object? extra) predicate;

  const LogFilterByExtraImpl(this.predicate);

  @override
  bool shouldLog(LogEvent event) => predicate(event.extra);
}
