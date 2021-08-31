import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/filter.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogOutputFilteredImpl implements LogOutput {
  final LogFilter filter;

  final LogOutput child;

  const LogOutputFilteredImpl({
    required this.filter,
    required this.child,
  });

  @override
  void init() {
    child.init();
  }

  @override
  void write(LogEvent event) {
    if (filter.shouldLog(event)) {
      child.write(event);
    }
  }

  @override
  void close() {
    child.close();
  }
}
