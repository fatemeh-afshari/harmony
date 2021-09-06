import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';
import 'package:harmony_log/src/filter/filter.dart';
import 'package:meta/meta.dart';

@internal
class NotLogFilter extends AbstractLogFilter {
  final LogFilter m;

  const NotLogFilter(this.m);

  @override
  bool shouldLog(LogEvent event) => !m.shouldLog(event);
}
