import 'package:harmony_log/src/plain/output/output.dart';

class LogPlainOutputNoopImpl implements LogPlainOutput {
  const LogPlainOutputNoopImpl();

  @override
  void init() {}

  @override
  void write(Iterable<String> list) {}

  @override
  void close() {}
}
