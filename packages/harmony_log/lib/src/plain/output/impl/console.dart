import 'package:harmony_log/src/plain/output/output.dart';

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
