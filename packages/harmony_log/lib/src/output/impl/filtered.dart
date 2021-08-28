import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/filter.dart';
import 'package:harmony_log/src/output/output.dart';

class LogOutputFilteredImpl implements LogOutput {
  final LogFilter filter;

  final LogOutput child;

  const LogOutputFilteredImpl({
    required this.filter,
    required this.child,
  });

  @override
  void close() {
    // nothing
  }

  @override
  void init() {
    // nothing
  }

  @override
  void write(LogEvent event) {
    // nothing
  }
}
