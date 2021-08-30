import 'package:harmony_log/src/plain/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogPlainOutputConsoleImpl implements LogPlainOutput {
  const LogPlainOutputConsoleImpl();

  @override
  void init() {}

  @override
  void write(Iterable<String> list) {
    for (final m in list) {
      print(m);
    }
  }

  @override
  void close() {}
}
