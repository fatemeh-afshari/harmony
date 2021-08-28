import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';

class LogOutputMultiImpl implements LogOutput {
  final List<LogOutput> outputs;

  const LogOutputMultiImpl(this.outputs);

  @override
  void init() {
    for (final output in outputs) {
      output.init();
    }
  }

  @override
  void write(LogEvent event) {
    for (final output in outputs) {
      output.write(event);
    }
  }

  @override
  void close() {
    for (final output in outputs) {
      output.close();
    }
  }
}
