import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';

class LogOutputRedirectImpl implements LogOutput {
  final LogOutput child;

  const LogOutputRedirectImpl(this.child);

  @override
  void init() {
    child.init();
  }

  @override
  void write(LogEvent event) {
    child.write(event);
  }

  @override
  void close() {
    child.close();
  }
}
