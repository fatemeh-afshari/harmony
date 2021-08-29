import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogOutputNoopImpl implements LogOutput {
  const LogOutputNoopImpl();

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
