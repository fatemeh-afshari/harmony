import 'package:harmony_log/src/plain/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogPlainOutputMultiImpl implements LogPlainOutput {
  final List<LogPlainOutput> children;

  const LogPlainOutputMultiImpl({required this.children});

  @override
  void init() {
    for (final output in children) {
      output.init();
    }
  }

  @override
  void write(Iterable<String> list) {
    for (final output in children) {
      output.write(list);
    }
  }

  @override
  void close() {
    for (final output in children) {
      output.close();
    }
  }
}
