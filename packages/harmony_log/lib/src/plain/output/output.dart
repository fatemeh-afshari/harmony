import 'package:harmony_log/src/plain/output/impl/console.dart';

abstract class LogPlainOutput {
  /// console implementation
  const factory LogPlainOutput.console() = LogPlainOutputConsoleImpl;

  void init();

  void write(Iterable<String> list);

  void close();
}
