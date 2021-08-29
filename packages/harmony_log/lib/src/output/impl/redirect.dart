import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogOutputRedirectImpl implements LogOutput {
  final bool enabled;

  final LogOutput child;

  const LogOutputRedirectImpl({
    this.enabled = true,
    required this.child,
  });

  @override
  void init() {
    if (enabled) {
      child.init();
    }
  }

  @override
  void write(LogEvent event) {
    if (enabled) {
      child.write(event);
    }
  }

  @override
  void close() {
    if (enabled) {
      child.close();
    }
  }
}
