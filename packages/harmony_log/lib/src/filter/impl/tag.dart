import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';
import 'package:meta/meta.dart';

@internal
class LogFilterTagImpl extends AbstractLogFilter {
  final String? tag;

  const LogFilterTagImpl(this.tag);

  @override
  bool shouldLog(LogEvent event) => event.tag == tag;
}
