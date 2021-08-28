import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';

class LogOutputMultiImpl implements LogOutput {
  final List<LogOutput> children;

  const LogOutputMultiImpl({required this.children});

  @override
  void init() {
    for (final output in children) {
      output.init();
    }
  }

  @override
  void write(LogEvent event) {
    for (final output in children) {
      output.write(event);
    }
  }

  @override
  void close() {
    for (final output in children) {
      output.close();
    }
  }
}
